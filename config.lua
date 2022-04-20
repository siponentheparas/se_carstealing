Config = {}

Config.Currency = '€'

Config.GetMission = vector3(-601.42, -1127.78, 21.90)
Config.ReturnCar = vector3(-582.6, -1126.6, 22.18)
Config.GetReward = vector3(-602.02, -1122.11, 21.9)

Config.Locations = {
    {coords = vector3(512.0, -1992.93, 24.8), heading = 90},
    {coords = vector3(857.93, -1050.24, 28.81), heading = 103.45},
    {coords = vector3(76.91, 89.76, 78.71), heading = 70.52}
}

Config.Vehicles = { -- https://wiki.rage.mp/index.php?title=Vehicles
    {model = 'rhapsody', reward = 1000},
    {model = 'vigero', reward = 1000},
    {model = 'retinue', reward = 1000}
}

Config.Markers = {
    type = 27, -- https://docs.fivem.net/docs/game-references/markers/
    scale = 1.0,
    color = {r = 0, g = 0, b = 255}
}