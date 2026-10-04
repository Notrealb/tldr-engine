visible = false;

var _list = ds_list_create();
var _num = instance_place_list(x, y, o_plat_bullet, _list, false);
if (_num > 0) {
	for (var i = 0; i < _num; ++i) {
		with (_list[| i]) {
			dodgeaura_radius = 60;
		}
	}
}
ds_list_destroy(_list);

instance_destroy();