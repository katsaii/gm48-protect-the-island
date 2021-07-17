/* Extendable UI and Input System
 * ------------------------------
 * Kat @katsaii
 */

#macro __UI_UNIMPLEMENTED show_error("unimplemented UI function", true)

#macro UI_MENU_DEFAULT_WIDTH 500
#macro UI_MENU_DEFAULT_HEIGHT 500

#macro __UI_INPUT_KEYBOARD_CHECK keyboard_check
#macro __UI_INPUT_KEYBOARD_CHECK_PRESSED keyboard_check_pressed
#macro __UI_INPUT_KEYBOARD_CHECK_RELEASED keyboard_check_released
#macro __UI_INPUT_MOUSE_CHECK_BUTTON mouse_check_button
#macro __UI_INPUT_MOUSE_CHECK_BUTTON_PRESSED mouse_check_button_pressed
#macro __UI_INPUT_MOUSE_CHECK_BUTTON_RELEASED mouse_check_button_released
#macro __UI_INPUT_MOUSE_WHEEL_UP mouse_wheel_up
#macro __UI_INPUT_MOUSE_WHEEL_DOWN mouse_wheel_down
#macro keyboard_check __ui_input_keyboard_check_checked
#macro keyboard_check_pressed __ui_input_keyboard_check_pressed_checked
#macro keyboard_check_released __ui_input_keyboard_check_released_checked
#macro mouse_check_button __ui_input_mouse_check_button_checked
#macro mouse_check_button_pressed __ui_input_mouse_check_button_pressed_checked
#macro mouse_check_button_released __ui_input_mouse_check_button_released_checked
#macro mouse_wheel_up __ui_input_mouse_wheel_up_checked
#macro mouse_wheel_down __ui_input_mouse_wheel_down_checked

/// @desc Returns a reference to the UI controller.
function __ui_manager() {
    static ui = (function() {
        var input_values = ds_grid_create(0xff, 3);
        ds_grid_set_region(input_values, 0, 0, 0xfe, 1, 0.0);
        ds_grid_set_region(input_values, 0, 2, 0xfe, 2, undefined);
        return {
            submenus : ds_stack_create(),
            menu : undefined,
            debugMode : false,
            input : {
                mouseX : 0,
                mouseY : 0,
                mouseDX : 0,
                mouseDY : 0,
                mousePressed : __ui_input_mouse_check_button_pressed,
                mouseHeld : __ui_input_mouse_check_button,
                mouseReleased : __ui_input_mouse_check_button_released,
                keyPressed : __ui_input_keyboard_check_pressed,
                keyHeld : __ui_input_keyboard_check,
                keyReleased : __ui_input_keyboard_check_released,
                wheelUp : __ui_input_mouse_wheel_up,
                wheelDown : __ui_input_mouse_wheel_down
            },
            left : 0,
            top : 0,
            right : UI_MENU_DEFAULT_WIDTH,
            bottom : UI_MENU_DEFAULT_HEIGHT,
            values : input_values,
            anykey : {
                key : vk_nokey,
                pressed : false,
                released : false
            },
            key : undefined
        };
    })();
    return ui;
}

/// @desc Returns a reference to the UI controller.
function __ui_manager_assert_menu_exists() {
    var ui = __ui_manager();
    if (ui.menu == undefined) {
        show_error("no active menus exist", true);
    }
    return ui;
}

/// @desc Attempts to get a value from a struct if it exists, otherwise a default value is used.
/// @param {struct} base The struct to pull an event from.
/// @param {string} name The name of the member.
/// @param {value} default The default value.
function __ui_struct_get_or_default(_struct, _name, _default) {
    return variable_struct_exists(_struct, _name) ? _struct[$ _name] : _default;
}

/// @desc Creates a new event from this struct.
/// @param {struct} base The struct to pull an event from.
/// @param {string} name The name of the event.
function __ui_struct_get_event(_base, _name) {
    var f = __ui_struct_get_or_default(_base, _name, undefined);
    if (is_method(f)) {
        return _base == method_get_self(f) ? method(self, f) : f;
    } else if (is_numeric(f) && script_exists(f)) {
        return f;
    } else {
        return undefined;
    }
}

/// @desc Forces a refresh of the entire UI.
function ui_menu_force_refresh() {
    var ui = __ui_manager();
    var menu = ui.menu;
    if (menu == undefined) {
        return;
    }
    __ui_update_layout(menu, ui.left, ui.top, ui.right, ui.bottom);
    var elements = menu.elements;
    var element_count = array_length(elements);
    for (var i = 0; i < element_count; i += 1) {
        var element = elements[i];
        if (element.dynamic) {
            continue;
        }
        array_push(menu.refreshQueue, element);
    }
}

/// @desc Enables the menu debug overlay.
/// @param {bool} enable Whether to enable the debug overlay.
function ui_menu_debug_overlay(_enable) {
    __ui_manager().debugMode = is_numeric(_enable) && _enable;
}

/// @desc Updates the menu stage.
/// @param {real} x The x position of the stage.
/// @param {real} y The y position of the stage.
/// @param {real} width The width of the stage.
/// @param {real} height The height of the stage.
function ui_menu_set_position(_x, _y, _width, _height) {
    var ui = __ui_manager();
    ui.left = _x;
    ui.top = _y;
    ui.right = _x + _width;
    ui.bottom = _y + _height;
    ui_menu_force_refresh();
}

/// @desc Begins a new UI menu.
/// @param {struct} [menu_data] The menu template to construct.
function ui_menu_push(_menu_data=undefined) {
    var ui = __ui_manager();
    if (ui.menu != undefined) {
        ds_stack_push(ui.submenus, ui.menu);
    }
    var menu = {
        left : 0,
        top : 0,
        right : 0,
        bottom : 0,
        elements : [],
        elementNames : [],
        refreshQueue : [],
        hover : undefined,
        selection : undefined,
        input : ui.input,
        shared : { },
        onOpen : undefined,
        onClose : undefined,
        onLayout : undefined,
        onDraw : undefined,
        onDebug : undefined,
        onUpdate : undefined,
        run : function(_event, _arg) {
            return __ui_menu_run_event(_event, {
                left : left,
                top : top,
                right : right,
                bottom : bottom,
                shared : shared,
                input : input,
                arg : _arg
            });
        }
    };
    ui.menu = menu;
    if (is_struct(_menu_data)) {
        menu.onOpen = __ui_struct_get_event(_menu_data, "open");
        menu.onClose = __ui_struct_get_event(_menu_data, "close");
        menu.onLayout = __ui_struct_get_event(_menu_data, "layout");
        menu.onDraw = __ui_struct_get_event(_menu_data, "draw");
        menu.onDebug = __ui_struct_get_event(_menu_data, "debug");
        menu.onUpdate = __ui_struct_get_event(_menu_data, "update");
        var elements = __ui_struct_get_or_default(_menu_data, "elements", { });
        var names = variable_struct_get_names(elements);
        for (var i = array_length(names) - 1; i >= 0; i -= 1) {
            var name = names[i];
            var element = elements[$ name];
            ui_menu_element_add(name, element);
        }
    }
    ui_menu_force_refresh();
    menu.run(menu.onOpen);
}

/// @desc Pops the current menu from the UI stack.
function ui_menu_pop() {
    var ui = __ui_manager_assert_menu_exists();
    var menu = ui.menu;
    menu.run(menu.onClose);
    ui.menu = ds_stack_pop(ui.submenus);
    ui_menu_force_refresh();
}

/// @desc Runs this event if it exists.
/// @param {method} event The event to execute.
/// @param {value} arg The argument to call the event with.
function __ui_menu_run_event(_event, _arg) {
    return _event != undefined ? _event(_arg) : undefined;
}

/// @desc Represents an element selection type.
enum UIMenuSelectionType {
    ANCHOR,
    HOLD
}

/// @desc Adds a new element with this name to the current menu.
/// @param {string} name The name of the element to add.
/// @param {struct} element_data The element template to construct.
function ui_menu_element_add(_name, _element_data) {
    var ui = __ui_manager_assert_menu_exists();
    var menu = ui.menu;
    var element = {
        left : 0,
        top : 0,
        right : 0,
        bottom : 0,
        name : _name,
        hover : false,
        focus : false,
        input : ui.input,
        shared : menu.shared,
        meta : __ui_struct_get_or_default(_element_data, "meta", { }),
        navigatable : __ui_struct_get_or_default(_element_data, "navigatiable", true),
        dynamic : __ui_struct_get_or_default(_element_data, "dynamic", false),
        selectionType : __ui_struct_get_or_default(_element_data, "selectionType", UIMenuSelectionType.HOLD),
        onLayout : __ui_struct_get_event(_element_data, "layout"),
        onDraw : __ui_struct_get_event(_element_data, "draw"),
        onDebug : __ui_struct_get_event(_element_data, "debug"),
        onUpdate : __ui_struct_get_event(_element_data, "update"),
        onEnter : __ui_struct_get_event(_element_data, "enter"),
        onExit : __ui_struct_get_event(_element_data, "leave"),
        onSelected : __ui_struct_get_event(_element_data, "selected"),
        onDeselected : __ui_struct_get_event(_element_data, "deselected"),
        run : function(_event, _arg) {
            return __ui_menu_run_event(_event, {
                left : left,
                top : top,
                right : right,
                bottom : bottom,
                name : name,
                hover : hover,
                focus : focus,
                input : input,
                shared : shared,
                meta : meta,
                arg : _arg
            });
        }
    };
    if (element.dynamic) {
        array_push(menu.refreshQueue, element);
    }
    array_push(menu.elements, element);
    array_push(menu.elementNames, _name);
}

/// @desc Removes an existing element from the current menu.
/// @param {string} name The name of the element to remove.
function ui_menu_element_remove(_name) {
    var ui = __ui_manager_assert_menu_exists();
    var menu = ui.menu;
    var pos = array_find_index(menu.elementNames, _name); // not very performant, but it's fiiine
    if (pos >= 0) {
        array_delete(menu.elements, pos, 1);
        array_delete(menu.elementNames, pos, 1);
    }
}

/// @desc Draws the menu elements.
function ui_menu_draw() {
    var ui = __ui_manager();
    var menu = ui.menu;
    if (menu == undefined) {
        return;
    }
    var debug = ui.debugMode;
    menu.run(menu.onDraw);
    if (debug) {
        var c = c_purple;
        draw_rectangle_color(menu.left, menu.top, menu.right, menu.bottom, c, c, c, c, true);
        menu.run(menu.onDebug);
    }
    var elements = menu.elements;
    var element_count = array_length(elements);
    for (var i = 0; i < element_count; i += 1) {
        var element = elements[i];
        var left = element.left;
        var top = element.top;
        var right = element.right;
        var bottom = element.bottom;
        if (left > right || top > bottom) {
            // this menu element is inside-out, so ignore it
            continue;
        }
        element.run(element.onDraw);
        if (debug) {
            var c = c_blue;
            if (element.hover) {
                c = c_yellow;
            } else if not (element.navigatable) {
                c = c_red;
            }
            if (element.focus) {
                var alpha = draw_get_alpha();
                draw_set_alpha(0.5);
                draw_rectangle_color(left, top, right, bottom, c, c, c, c, false);
                draw_set_alpha(alpha);
            }
            draw_rectangle_color(left, top, right, bottom, c, c, c, c, true);
            element.run(element.onDebug);
        }
    }
}

/// @desc Sets the input predicate for this key.
/// @param {real} vk The virtual key to update.
/// @param {value} script_or_key The script or key to check for.
function ui_input_set_handler(_vk, _p) {
	__ui_manager().values[# _vk, 2] = _p;
}

/// @desc Returns the final bounds of this element along an arbitrary axis.
/// @param {real} a The smaller layout argument.
/// @param {real} b The larger layout argument.
/// @param {real} length The size of the layout.
/// @param {real} min The minimum boundary.
/// @param {real} max The maximum boundary.
function __ui_menu_make_layout(_a, _b, _length, _min, _max) {
    if (_length == undefined) {
        if (_a == undefined) {
            _a = 0;
        }
        if (_b == undefined) {
            _b = 0;
        }
        _a = _min + _a;
        _b = _max - _b;
    } else {
        if (_a == undefined && _b == undefined) {
            _a = 0;
            _b = 0;
        }
        if (_b == undefined) {
            _a = _min + _a;
            _b = _a + _length;
        } else if (_a == undefined) {
            _b = _max - _b;
            _a = _b - _length;
        } else {
            var mid = mean(_min + _a, _max - _b);
            _a = mid - _length / 2;
            _b = _a + _length;
        }
    }
    return [_a, _b];
}

/// @desc Attempts to find a menu element at this position.
/// @param {array} elements The array of elements to check.
/// @param {real} x The x position to check.
/// @param {real} y The y position to check.
function __ui_find_element_at_position(_elements, _x, _y) {
    for (var i = array_length(_elements) - 1; i >= 0; i -= 1) {
        var element = _elements[i];
        if (point_in_rectangle(_x, _y, element.left, element.top, element.right, element.bottom)) {
            if not (element.navigatable) {
                break;
            }
            return element;
        }
    }
    return undefined;
}

/// @desc Attempts to find a menu element that is nearest to this position.
/// @param {array} elements The array of elements to check.
/// @param {real} ox The x position to check.
/// @param {real} oy The y position to check.
/// @param {real} x1 The left position of the region to check.
/// @param {real} y1 The top position of the region to check.
/// @param {real} x2 The right position of the region to check.
/// @param {real} y2 The bottom position of the region to check.
function __ui_find_element_nearest_to_position(_elements, _x, _y, _left, _top, _right, _bottom) {
    var closest = undefined;
    var closest_dist = infinity;
    for (var i = array_length(_elements) - 1; i >= 0; i -= 1) {
        var element = _elements[i];
        var eleft = element.left;
        var etop = element.top;
        var eright = element.right;
        var ebottom = element.bottom;
        if not (element.navigatable &&
                rectangle_in_rectangle(eleft, etop, eright, ebottom, _left, _top, _right, _bottom)) {
            continue;
        }
        var dist = point_distance(_x, _y, clamp(_x, eleft, eright), clamp(_y, etop, ebottom));
        if (dist < closest_dist) {
            closest = element;
            closest_dist = dist;
        }
    }
    return closest;
}

/// @desc Checks whether an input is held.
/// @param {real} vk The virtual key to check.
/// @param {real} vk_anykey The virtual key which represents anykey.
/// @param {real} vk_nokey The virtual key which represents nokey.
function __ui_input_check(_vk, _vk_anykey, _vk_nokey) {
    var ui = __ui_manager();
    if (_vk == _vk_anykey) {
        return ui.anykey.key != vk_nokey;
    } else if (_vk == _vk_nokey) {
        return ui.anykey.key == vk_nokey;
    } else {
        return ui.values[# _vk, 0]
    }
}

/// @desc Checks whether an input was pressed.
/// @param {real} vk The virtual key to check.
/// @param {real} vk_anykey The virtual key which represents anykey.
/// @param {real} vk_nokey The virtual key which represents nokey.
function __ui_input_check_pressed(_vk, _vk_anykey, _vk_nokey) {
    var ui = __ui_manager();
    if (_vk == _vk_anykey) {
        return ui.anykey.pressed;
    } else if (_vk == _vk_nokey) {
        return ui.anykey.released;
    } else {
        var input_values = ui.values;
        return input_values[# _vk, 0] > input_values[# _vk, 1];
    }
}

/// @desc Checks whether an input was released.
/// @param {real} vk The virtual key to check.
/// @param {real} vk_anykey The virtual key which represents anykey.
/// @param {real} vk_nokey The virtual key which represents nokey.
function __ui_input_check_released(_vk, _vk_anykey, _vk_nokey) {
    var ui = __ui_manager();
    if (_vk == _vk_anykey) {
        return ui.anykey.released;
    } else if (_vk == _vk_nokey) {
        return ui.anykey.pressed;
    } else {
        var input_values = ui.values;
        return input_values[# _vk, 0] < input_values[# _vk, 1];
    }
}

/// @desc Checks whether a keyboard key is held.
/// @param {real} vk The keyboard key to check.
function __ui_input_keyboard_check(_vk) {
    return __UI_INPUT_KEYBOARD_CHECK(_vk) ? 1.0 : __ui_input_check(_vk, vk_anykey, vk_nokey);
}

/// @desc Checks whether a keyboard key was pressed.
/// @param {real} vk The keyboard key to check.
function __ui_input_keyboard_check_pressed(_vk) {
    return __UI_INPUT_KEYBOARD_CHECK_PRESSED(_vk) ? 1.0 : __ui_input_check_pressed(_vk, vk_anykey, vk_nokey);
}

/// @desc Checks whether a keyboard key was released.
/// @param {real} vk The keyboard key to check.
function __ui_input_keyboard_check_released(_vk) {
    return __UI_INPUT_KEYBOARD_CHECK_RELEASED(_vk) ? 1.0 : __ui_input_check_released(_vk, vk_anykey, vk_nokey);
}

/// @desc Checks whether a mouse button is held.
/// @param {real} mb The mouse button to check.
function __ui_input_mouse_check_button(_mb) {
    return __UI_INPUT_MOUSE_CHECK_BUTTON(_mb) ? 1.0 : __ui_input_check(_mb, mb_any, mb_none);
}

/// @desc Checks whether a mouse button was pressed.
/// @param {real} vk The mouse button to check.
function __ui_input_mouse_check_button_pressed(_mb) {
    return __UI_INPUT_MOUSE_CHECK_BUTTON_PRESSED(_mb) ? 1.0 : __ui_input_check_pressed(_mb, mb_any, mb_none);
}

/// @desc Checks whether a mouse button was released.
/// @param {real} vk The mouse button to check.
function __ui_input_mouse_check_button_released(_mb) {
    return __UI_INPUT_MOUSE_CHECK_BUTTON_RELEASED(_mb) ? 1.0 : __ui_input_check_released(_mb, mb_any, mb_none);
}

/// @desc Checks whether the scroll wheel was scrolled up.
function __ui_input_mouse_wheel_up() {
    return __UI_INPUT_MOUSE_WHEEL_UP();
}

/// @desc Checks whether the scroll wheel was scrolled down.
function __ui_input_mouse_wheel_down() {
    return __UI_INPUT_MOUSE_WHEEL_DOWN();
}

/// @desc Checks whether a keyboard key is held. Always returns false if a menu is open.
/// @param {real} vk The keyboard key to check.
function __ui_input_keyboard_check_checked(_vk) {
    return __ui_manager().menu != undefined ? 0.0 : __ui_input_keyboard_check(_vk);
}

/// @desc Checks whether a keyboard key was pressed. Always returns false if a menu is open.
/// @param {real} vk The keyboard key to check.
function __ui_input_keyboard_check_pressed_checked(_vk) {
    return __ui_manager().menu != undefined ? 0.0 : __ui_input_keyboard_check_pressed(_vk);
}

/// @desc Checks whether a keyboard key was released. Always returns false if a menu is open.
/// @param {real} vk The keyboard key to check.
function __ui_input_keyboard_check_released_checked(_vk) {
    return __ui_manager().menu != undefined ? 0.0 : __ui_input_keyboard_check_released(_vk);
}

/// @desc Checks whether a mouse button is held. Always returns false if a menu is open.
/// @param {real} mb The mouse button to check.
function __ui_input_mouse_check_button_checked(_mb) {
    return __ui_manager().menu != undefined ? 0.0 : __ui_input_mouse_check_button(_vk);
}

/// @desc Checks whether a mouse button was pressed. Always returns false if a menu is open.
/// @param {real} vk The mouse button to check.
function __ui_input_mouse_check_button_pressed_checked(_mb) {
    return __ui_manager().menu != undefined ? 0.0 : __ui_input_mouse_check_button_pressed(_vk);
}

/// @desc Checks whether a mouse button was released. Always returns false if a menu is open.
/// @param {real} vk The mouse button to check.
function __ui_input_mouse_check_button_released_checked(_mb) {
    return __ui_manager().menu != undefined ? 0.0 : __ui_input_mouse_check_button_released(_vk);
}

/// @desc Checks whether the scroll wheel was scrolled up. Always returns false if a menu is open.
function __ui_input_mouse_wheel_up_checked() {
    return __ui_manager().menu != undefined ? 0.0 : __ui_input_mouse_wheel_up(_vk);
}

/// @desc Checks whether the scroll wheel was scrolled down. Always returns false if a menu is open.
function __ui_input_mouse_wheel_down_checked() {
    return __ui_manager().menu != undefined ? 0.0 : __ui_input_mouse_wheel_down(_vk);
}

/// @desc Updates the layout of this menu, element, or view.
/// @param {struct} container The container to update the layout for.
/// @param {real} parent_left The left position of the parent container.
/// @param {real} parent_top The top position of the parent container.
/// @param {real} parent_right The right position of the parent container.
/// @param {real} parent_bottom The bottom position of the parent container.
function __ui_update_layout(_container, _parent_left, _parent_top, _parent_right, _parent_bottom) {
    var layout = _container.run(_container.onLayout);
    var left = undefined;
    var top = undefined;
    var right = undefined;
    var bottom = undefined;
    var width = undefined;
    var height = undefined;
    if (is_struct(layout)) {
        left = __ui_struct_get_or_default(layout, "left", undefined);
        top = __ui_struct_get_or_default(layout, "top", undefined);
        right = __ui_struct_get_or_default(layout, "right", undefined);
        bottom = __ui_struct_get_or_default(layout, "bottom", undefined);
        width = __ui_struct_get_or_default(layout, "width", undefined);
        height = __ui_struct_get_or_default(layout, "height", undefined);
    }
    var layout_x = __ui_menu_make_layout(left, right, width, _parent_left, _parent_right);
    var layout_y = __ui_menu_make_layout(top, bottom, height, _parent_top, _parent_bottom);
    _container.left = layout_x[0];
    _container.top = layout_y[0];
    _container.right = layout_x[1];
    _container.bottom = layout_y[1];
}

/// @desc Updates the menu elements and input system.
/// @param {real} mouse_x The x position of the mouse.
/// @param {real} mouse_y The y position of the mouse.
function ui_update(_mouse_x, _mouse_y) {
    var ui = __ui_manager();
    var input_values = ui.values;
    ds_grid_set_grid_region(input_values, input_values, 0, 0, 0xfe, 0, 0, 1);
    ds_grid_set_region(input_values, 0, 0, 0xfe, 0, 0.0);
    if (window_has_focus()) {
        var anykey_key = vk_nokey;
        var anykey_pressed = false;
        var anykey_released = false;
        for (var i = 0xfe; i >= 0; i -= 1) {
            var event = input_values[# i, 2];
            var value = 0.0;
            if (is_method(event)) {
                var candidate = event();
                if (is_numeric(candidate)) {
                    value = candidate;
                }
            } else {
                switch (event) {
                case mb_left:
                case mb_right:
                case mb_middle:
                    value = __UI_INPUT_MOUSE_CHECK_BUTTON(event);
                    break;
                default:
                    if (event > 0x00 && event < 0xff) {
                        value = __UI_INPUT_KEYBOARD_CHECK(event);
                    }
                }
            }
            if (value > input_values[# i, 0]) {
                input_values[# i, 0] = value;
            }
            // update anykey
            var held = input_values[# i, 0] != 0.0;
            var held_previous = input_values[# i, 1] != 0.0;
            if (held) {
                anykey_key = held;
                if not (held_previous) {
                    anykey_pressed = true;
                }
            } else if (held_previous) {
                anykey_released = true;
            }
        }
        var anykey = ui.anykey;
        anykey.key = anykey_key;
        anykey.pressed = anykey_pressed;
        anykey.released = anykey_released;
    }
    var input = ui.input;
    var menu = ui.menu;
    if (menu == undefined) {
        return;
    }
    menu.run(menu.onUpdate);
    var menu_left = menu.left;
    var menu_top = menu.top;
    var menu_right = menu.right;
    var menu_bottom = menu.bottom;
    var refresh_queue = menu.refreshQueue;
    var elements = menu.elements;
    repeat (array_length(refresh_queue)) {
        // forced update of elements
        var element = array_pop(refresh_queue);
        if (element.dynamic) {
            // add back dynamic element to be updated again
            array_push(refresh_queue, element);
        }
        __ui_update_layout(element, menu_left, menu_top, menu_right, menu_bottom);
    }
    var mouse_dx = _mouse_x - input.mouseX;
    var mouse_dy = _mouse_y - input.mouseY;
    var prev_hover = menu.hover;
    var next_hover = prev_hover;
    if (mouse_dx != 0 || mouse_dy != 0) {
        input.mouseX = _mouse_x;
        input.mouseY = _mouse_y;
        input.mouseDX = mouse_dx;
        input.mouseDY = mouse_dy;
        next_hover = __ui_find_element_at_position(elements, _mouse_x, _mouse_y);
    } else {
        input.mouseDX = 0;
        input.mouseDY = 0;
    }
    var selection = menu.selection;
    if (selection == undefined) {
        var keyboard_dx = input.keyPressed(vk_right) - input.keyPressed(vk_left);
        var keyboard_dy = input.keyPressed(vk_down) - input.keyPressed(vk_up);
        if (keyboard_dx != 0 || keyboard_dy != 0) {
            if (next_hover == undefined) {
                next_hover = __ui_find_element_nearest_to_position(
                        elements, _mouse_x, _mouse_y, menu_left, menu_top, menu_right, menu_bottom);
            } else {
                var nav_padding = 1;
                var hover_left = next_hover.left - nav_padding;
                var hover_top = next_hover.top - nav_padding;
                var hover_right = next_hover.right + nav_padding;
                var hover_bottom = next_hover.bottom + nav_padding;
                var nav_left = keyboard_dx < 0 ? menu_left : hover_right;
                var nav_top = keyboard_dy < 0 ? menu_top : hover_bottom;
                var nav_right = keyboard_dx > 0 ? menu_right : hover_left;
                var nav_bottom = keyboard_dy > 0 ? menu_bottom : hover_top;
                var nav_x = mean(hover_left, hover_right);
                var nav_y = mean(hover_top, hover_bottom);
                var candidate = __ui_find_element_nearest_to_position(
                        elements, nav_x, nav_y, nav_left, nav_top, nav_right, nav_bottom);
                if (candidate != undefined) {
                    next_hover = candidate;
                }
            }
        }
    }
    if (prev_hover != next_hover) {
        menu.hover = next_hover;
        if (prev_hover != undefined) {
            prev_hover.run(prev_hover.onExit);
            prev_hover.hover = false;
        }
        if (next_hover != undefined) {
            next_hover.run(next_hover.onEnter);
            next_hover.hover = true;
        }
    }
    var update = true;
    if (input.mousePressed(mb_left) || input.keyPressed(vk_enter)) {
        var prev_selection = selection;
        var next_selection = next_hover;
        if (prev_selection != next_selection) {
            update = false;
            menu.selection = next_selection;
            if (prev_selection != undefined) {
                prev_selection.run(prev_selection.onDeselected);
                prev_selection.focus = false;
            }
            if (next_selection != undefined) {
                next_selection.run(next_selection.onSelected);
                next_selection.focus = true;
            }
        }
    }
    if (update && selection != undefined) {
        var deselect = (selection.selectionType == UIMenuSelectionType.HOLD &&
                !(input.mouseHeld(mb_left) || input.keyHeld(vk_enter)) ||
                input.keyPressed(vk_escape));
        if (deselect) {
            menu.selection = undefined;
            selection.run(selection.onDeselected);
            selection.focus = false;
        } else {
            selection.run(selection.onUpdate);
        }
    }
}