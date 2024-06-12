//c2t apron relay
//c2t

//relay script for c2t_apron settings

string[string] POST = form_fields();

string c2t_apron_relay_text(string tag,string s);
buffer c2t_apron_relay_form();
buffer c2t_apron_relay_multiSelect(string id);
buffer c2t_apron_relay_failSuccess();
boolean[string] c2t_apron_relay_allowlist();

void main() {
	buffer out;

	if (POST["wearego"] == "omghi2u") {
		string list;
		foreach key,val in POST
			if (key != "relay" && key != "wearego")
				list += list == "" ? val : `,{val}`;
		set_property("c2t_apron_allowlist",list);
	}

	out.append('<!DOCTYPE html><html lang="EN"><head><title>c2t_apron relay</title>');
	out.append("<style>p.error {color:#f00;background-color:#000;padding:10px;font-weight:bold;} p.success {color:#00f;} th {font-weight:extra-bold;padding:5px 10px 5px 10px;} thead {background-color:#000;color:#fff;} tr:nth-child(even) {background-color:#ddd;} table {border-style:solid;border-width:1px;} input.submit {margin:12pt;padding:5px;} td {padding:0 5px 0 5px;}</style>");
	out.append("</head><body>");
	out.append(c2t_apron_relay_text("h1","c2t_apron"));
	out.append(c2t_apron_relay_text("p",'No changes will be made until the "save changes" button is used at the bottom.'));
	out.append(c2t_apron_relay_text("h2","Ingredient Allowlist"));
	out.append(c2t_apron_relay_text("p",'Select every ingredient you want to allow to be used in the Black and White Apron Meal Kit. See <a href="https://kol.coldfront.net/thekolwiki/index.php/Prepare_your_Meal" target="_blank">the kolwiki article</a> for what each ingredient does.'));
	out.append(c2t_apron_relay_form());
	out.append("</body></html>");
	out.write();
}

string c2t_apron_relay_text(string tag,string s) {
	return `<{tag}>{s}</{tag.split_string(" ")[0]}>`;
}

buffer c2t_apron_relay_form() {
	buffer out;
	out.append('<form action="" method="post">');
	out.append('<input type="hidden" name="wearego" value="omghi2u" />');
	out.append('<table><thead><tr>');
	out.append('<th><label for="ingredients">regular ingredients</label></th><th><label for="ingredient5">5th ingredient<label></th>');
	out.append('</tr></thead><tr>');
	out.append(`<td>{c2t_apron_relay_multiSelect("ingredients")}</td>`);
	out.append(`<td>{c2t_apron_relay_multiSelect("ingredient5")}`);
	out.append('<br /><input type="submit" value="save changes" class="submit" />');
	out.append(c2t_apron_relay_failSuccess());
	out.append("</td></tr></table></form>");
	return out;
}

buffer c2t_apron_relay_multiSelect(string id) {
	buffer out;
	boolean[string] allowlist = c2t_apron_relay_allowlist();

	string[string] data;
	file_to_map(`c2t_apron_{id}.dat`,data);

	out.append(`<select name="{id}" id="{id}" size="{data.count()}" multiple>`);
	foreach key,val in data
		out.append(`<option value="{val}"{allowlist contains val?' selected="selected"':""}>{key}</option>`);
	out.append("</select>");

	return out;
}

buffer c2t_apron_relay_failSuccess() {
	buffer out;
	boolean[string] allowlist = c2t_apron_relay_allowlist();
	if (POST["wearego"] == "omghi2u") {
		out.append(c2t_apron_relay_text('p class="success"',`changes saved with<br />{allowlist.count()} ingredients`));
	}
	return out;
}

boolean[string] c2t_apron_relay_allowlist() {
	boolean[string] out;
	string[int] split;

	if (get_property("c2t_apron_allowlist") != "")
		split = get_property("c2t_apron_allowlist").split_string(",");

	foreach i,x in split
		out[x] = true;

	return out;
}

