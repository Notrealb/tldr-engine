if target == noone exit

x = target.x;
y = target.bbox_top - 40;

if object_is_ancestor(target.object_index, o_actor) and target.is_party {
	image_blend = party_getdata(target.name, "color");
	//text = party_getdata(target.name, "name");
}