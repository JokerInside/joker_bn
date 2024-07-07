Config = {}
Config.Locale = GetConvar('esx:locale', 'en')
Config.Visible = false

--prop = "prop_cs_burger_01",
--prop = "prop_ld_flow_bottle",

Config.Items = {
-----------------------MAKANAN-----------------------
	["bread"] = {
		type = "food",
		prop = "",
		status = 100000,
		remove = true,
	},
	["burger"] = {
		type = "food",
		prop = "",
		status = 150000,
		remove = true,
	},
	["pizza"] = {
		type = "food",
		prop = "",
		status = 200000,
		remove = true,
	},
-----------------------MINUMAN-----------------------
	["water"] = {
		type = "drink",
		prop = "",
		status = 100000,
		remove = true,
	},
	["cola"] = {
		type = "drink",
		prop = "",
		status = 150000,
		remove = true,
	},
	["beer"] = {
		type = "stress",
		prop = "",
		status = 100000,
		remove = true,
	}
	
	
	
	
}
