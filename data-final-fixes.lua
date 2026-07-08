local khaoslib_technology = require("__khaoslib__.technology")

local tech = khaoslib_technology:load("cubic-science-pack-productivity-infinite")
local packs = {
  "cerysian-science-pack-cubic",
  "cerys-space-science-pack-cubic",
}

for _, pack in pairs(packs) do
  tech:add_effect {
    type = "change-recipe-productivity",
    recipe = pack,
    change = 0.03
  }
end

tech:commit()
