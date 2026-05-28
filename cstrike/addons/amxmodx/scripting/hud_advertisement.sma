#include <amxmodx>
#include <amxmisc>

#define PLUGIN "Hud Advertisement"
#define VERSION "1.0"
#define AUTHOR "DadoDz"

new g_HudAdvertsSync;
new Array:g_hud_adverts_messages

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR);

    g_HudAdvertsSync = CreateHudSyncObj();

    load_hud_adverts();
}

load_hud_adverts()
{
	g_hud_adverts_messages = ArrayCreate(512)

	new config_path[256]
	get_configsdir(config_path, charsmax(config_path))
	add(config_path, charsmax(config_path), "/hud_advertisement.ini")

	new file = fopen(config_path, "r")
	if (!file) return;

	new line[512]
	while (!feof(file))
	{
		fgets(file, line, charsmax(line))
		trim(line)

		if (strlen(line) > 0 && line[0] != ';' && line[0] != '#' && line[0] != '/')
		{
			replace_all(line, charsmax(line), "\n", "^n")
			ArrayPushString(g_hud_adverts_messages, line)
		}
	}

	fclose(file)

	if (ArraySize(g_hud_adverts_messages) > 0)
		set_task(random_float(50.0, 70.0), "task_hud_adverts", _, _, _, "b")
}

public task_hud_adverts()
{
	if (!g_hud_adverts_messages || ArraySize(g_hud_adverts_messages) < 1)
		return

	static message[512]
	ArrayGetString(g_hud_adverts_messages, random_num(0, ArraySize(g_hud_adverts_messages) - 1), message, charsmax(message))

	for (new id = 1; id <= get_maxplayers(); id++)
	{
		if (is_user_connected(id) && !is_user_bot(id) && !is_user_hltv(id))
		{
			set_hudmessage(random_num(0, 255), random_num(0, 255), random_num(0, 255), -1.0, random_float(0.0777, 0.1325), random_num(0, 2), random_float(0.7, 0.9), 12.0, random_float(0.37, 0.4), random_float(0.37, 0.4), 4)
			ShowSyncHudMsg(id, g_HudAdvertsSync, message)
		}
	}
}
