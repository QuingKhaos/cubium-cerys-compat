local flib_locale = require("__flib__.locale")
local khaoslib_recipe = require("__khaoslib__.recipe")
local khaoslib_technology = require("__khaoslib__.technology")

if mods["science-tab"] then
  data:extend({
    {
      type = "item-subgroup",
      name = "cubic-cerys-science-pack",
      group = "science",
      order = "p[cubic-science]2",
    },
  })
end

local packs = {
  {
    name = "cerysian-science-pack",
    cubic = "cerysian-science-pack-cubic",
    recipe = "cerysian-science-pack",
    preq = "cerysian-science-pack",
    copy_tech = "cerys-space-science-pack-from-methane-ice"
  },
  {
    name = "space-science-pack",
    cubic = "cerys-space-science-pack-cubic",
    recipe = "cerys-space-science-pack-from-methane-ice",
    preq = "cerys-space-science-pack-from-methane-ice",
    copy_tech = "cerys-space-science-pack-from-methane-ice"
  },
}

for _, pack in pairs(packs) do
  if khaoslib_recipe.exists(pack.recipe) and data.raw["tool"][pack.name] then
    local order = data.raw["tool"][pack.name] and (data.raw["tool"][pack.name].order or nil) or nil
    order = data.raw["recipe"][pack.recipe] and (data.raw["recipe"][pack.recipe].order or order) or order

    local icons = {
      {icon = "__cubium__/graphics/icons/matter-cube.png", scale = 0.9},
    }

    if data.raw["recipe"][pack.recipe].icons ~= nil then
      for _, icon in pairs(data.raw["recipe"][pack.recipe].icons) do
        table.insert(icons, {icon = icon.icon, scale = icon.scale and icon.scale * 0.9 or 0.6, tint = icon.tint, shift = icon.shift})
      end
    else
      table.insert(icons, {icon = data.raw["recipe"][pack.recipe].icon or data.raw["tool"][pack.name].icon, scale = 0.6})
    end

    khaoslib_recipe.copy(pack.recipe, pack.cubic)
      :set_icons(icons)
      :set {
        subgroup = mods["cubium-science-pack-reorder"] and (mods["science-tab"] and "cubic-cerys-science-pack" or "cubic-science") or "cubic",
        localised_name = flib_locale.of("recipe", pack.recipe),
        enabled = false,
        allow_productivity = true,
        auto_recycle = false,
        result_is_always_fresh = true,
        order = order or "ab",
      }
      :add_ingredient {type = "item", name = "energized-microcube", amount = 1}
      :add_ingredient {type = "fluid", name = "dream-concentrate", amount = 200}
      :replace_result(function(result)
          return result.name == pack.name
        end, function(result)
          result.amount = result.amount * 4
          return result
        end)
      :add_result {type = "item", name = "dormant-microcube", amount = 1, percent_spoiled = 0, ignored_by_productivity = 9999, show_details_in_recipe_tooltip = false}
      :commit()

    khaoslib_technology.copy(pack.copy_tech, pack.cubic)
      :set_icons {
        {icon = "__cubium__/graphics/technology/ultradense-technology.png", icon_size = 256},
        {icon = data.raw["technology"][pack.name].icon, icon_size = data.raw["technology"][pack.name].icon_size, scale = 0.4, shift = {1, -10}},
      }
      :unset("localised_name")
      :unset("localised_description")
      :clear_prerequisites()
      :add_prerequisite("cube-mastery-4")
      :add_prerequisite(pack.preq)
      :set {unit = {time = 15, count = 1}}
      :add_science_pack {pack.name, 1}
      :clear_effects()
      :add_unlock_recipe(pack.cubic)
      :commit()
  end
end
