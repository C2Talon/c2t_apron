//c2t apron
//c2t

//deals with the black and white apron meal kit

//simply selects meal based on stat and selects all the extra ingredients that are available

//cli flag
boolean c2t_apron_cli = false;

//eats a meal kit with a provided stat
//returns true on success
boolean c2t_apron(stat select);
boolean c2t_apron() return c2t_apron(my_primestat());

//map of ingredients on the allowlist
boolean[string] c2t_apron_allowlist();

//errors
boolean c2t_apron_error(string msg);


//CLI handling
void main(string... stat_select) {
	c2t_apron_cli = true;

	if (stat_select.count() == 0)
		c2t_apron();
	else switch (stat_select[0].to_lower_case()) {
		default:
			c2t_apron_error(`"{stat_select[0]}" is not a valid stat`);
			break;
		case "mus":
		case "musc":
		case "muscle":
			c2t_apron($stat[muscle]);
			break;
		case "mys":
		case "myst":
		case "mysticality":
			c2t_apron($stat[mysticality]);
			break;
		case "mox":
		case "moxie":
			c2t_apron($stat[moxie]);
			break;
	}
}

boolean c2t_apron(stat select) {
	int meal;
	item kit = $item[black and white apron meal kit];
	buffer page;
	matcher mat;
	string sendit;
	int start = my_fullness();
	boolean[string] allowlist;

	switch (select) {
		default:
			return c2t_apron_error(`"{select}" is not a valid stat`);
		case $stat[muscle]:
			meal = 0;
			break;
		case $stat[mysticality]:
			meal = 1;
			break;
		case $stat[moxie]:
			meal = 2;
			break;
	}
	if (item_amount(kit) == 0)
		return c2t_apron_error(`no {kit} on hand`);
	if (my_fullness() + 3 > fullness_limit())
		return c2t_apron_error(`too full to eat a {kit}`);

	page = visit_url(`inv_use.php?pwd={my_hash()}&which=3&whichitem={kit.id}`,false,true);
	mat = create_matcher(`name="ingredients{meal}\\[\\]"\\s+value="(\\d+)"\\s+data-has="(\\d)"`,page);
	allowlist = c2t_apron_allowlist();

	sendit = `choice.php?pwd&whichchoice=1518&option=1&meal={meal}`;
	while (mat.find())
		if (mat.group(2) == "1" && allowlist contains mat.group(1))
			sendit += `&ingredients{meal}[]={mat.group(1)}`;

	visit_url(sendit,true,false);

	if (start < my_fullness())
		return true;
	return c2t_apron_error(`did not eat the {kit}`);
}

boolean[string] c2t_apron_allowlist() {
	boolean[string] out;
	string[int] split;

	if (get_property("c2t_apron_allowlist") != "")
		split = get_property("c2t_apron_allowlist").split_string(",");

	foreach i,x in split
		out[x] = true;

	return out;
}

boolean c2t_apron_error(string msg) {
	string out = "c2t_apron error: "+msg;

	if (c2t_apron_cli)
		abort(out);

	print(out,"red");
	return false;
}

