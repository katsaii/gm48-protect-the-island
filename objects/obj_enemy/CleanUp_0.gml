/// @desc Dispose of resources.
part_system_destroy(partSys);
audio_emitter_free(hurtEmitter);
repeat (choose(3, 6, 9)) {
    instance_create_layer(x, y, layer, obj_enemy_essence);
}