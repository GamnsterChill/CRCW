-- [[ Финальный Лоадер v10.0 | Classic Retro Craftwars Multi-Repo ]]
print("[CRCW Loader]: Начинаю сборку Elite Hub из 4 репозиториев...")

-- Последовательная и безопасная загрузка каждой части
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GamnsterChill/CRCW1/refs/heads/main/main.lua"))()
    task.wait(0.2)
end)

pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GamnsterChill/CRCW2/refs/heads/main/main.lua"))()
    task.wait(0.2)
end)

pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GamnsterChill/CRCW3/refs/heads/main/main.lua"))()
    task.wait(0.2)
end)

pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/GamnsterChill/CRCW4/refs/heads/main/main.lua"))()
end)

print("[CRCW Loader]: Все репозитории успешно объединены. Меню готово!")
