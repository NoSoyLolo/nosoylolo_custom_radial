local customData = {}

function UpdateRadialItems()
    local items = {}

    for i = 1, Config.MaxSlots do
        local slot = customData[i] or { cmd = '', label = 'Slot ' .. i, color = '#FFFFFF' }
        local cmd = slot.cmd
        local title = (slot.label and slot.label ~= '') and slot.label or ('Slot ' .. i)
        
        local displayLabel = (cmd and cmd ~= '') and (title .. '\n/' .. cmd) or (title .. '\n(Vacío)')
        table.insert(items, {
            id = 'custom_slot_' .. i,
            label = displayLabel,
            icon = { 'terminal', slot.color or '#FFFFFF' },
            onSelect = function()
                if cmd and cmd ~= '' then
                    ExecuteCommand(cmd)
                else
                    TriggerEvent('chat:addMessage', {
                        color = {255, 0, 0},
                        args = {'Sistema', 'Este slot está vacío. Usa /' .. Config.OpenSettingsCommand .. ' para configurarlo.'}
                    })
                end
            end
        })
    end

    for i = 1, Config.MaxSlots do
        lib.removeRadialItem('custom_slot_' .. i)
    end

    lib.addRadialItem(items)
end

CreateThread(function()
    Wait(1000)

    for i = 1, Config.MaxSlots do
        local savedCmd = GetResourceKvpString('radial_cmd_' .. i) or GetResourceKvpString('radial_slot_' .. i) or ''
        local savedLabel = GetResourceKvpString('radial_label_' .. i) or ('Slot ' .. i)
        local savedColor = GetResourceKvpString('radial_color_' .. i) or '#FFFFFF'

        customData[i] = {
            cmd = savedCmd,
            label = savedLabel,
            color = savedColor
        }
    end

    UpdateRadialItems()
end)

function OpenEditSlotDialog(slotIndex)
    local current = customData[slotIndex] or { cmd = '', label = 'Slot ' .. slotIndex, color = '#FFFFFF' }

    local input = lib.inputDialog('Configurar Slot ' .. slotIndex, {
        {
            type = 'input',
            label = 'Nombre del Slot',
            placeholder = 'Ej: Reparar, Bailar, Curar...',
            default = current.label
        },
        {
            type = 'input',
            label = 'Comando (sin la /)',
            placeholder = 'Ej: repair, e dance, heal...',
            default = current.cmd
        },
        {
            type = 'color',
            label = 'Color del Ícono',
            default = current.color or '#FFFFFF'
        }
    })

    if input then
        local newLabel = (input[1] and input[1] ~= '') and input[1] or ('Slot ' .. slotIndex)
        local cleanCmd = input[2]:gsub('^/', '')
        local newColor = input[3] or '#FFFFFF'

        customData[slotIndex] = {
            cmd = cleanCmd,
            label = newLabel,
            color = newColor
        }

        SetResourceKvp('radial_label_' .. slotIndex, newLabel)
        SetResourceKvp('radial_cmd_' .. slotIndex, cleanCmd)
        SetResourceKvp('radial_color_' .. slotIndex, newColor)

        UpdateRadialItems()

        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            args = {'Sistema', '¡Slot ' .. slotIndex .. ' (' .. newLabel .. ') guardado con éxito!'}
        })

        OpenRadialConfigMenu()
    end
end

function OpenRadialConfigMenu()
    local options = {}

    for i = 1, Config.MaxSlots do
        local slot = customData[i] or { cmd = '', label = 'Slot ' .. i, color = '#FFFFFF' }
        local subtitle = (slot.cmd and slot.cmd ~= '') and ('Comando: /' .. slot.cmd) or 'Sin comando asignado'

        table.insert(options, {
            title = i .. '. ' .. slot.label,
            description = subtitle,
            icon = 'terminal',
            iconColor = slot.color,
            onSelect = function()
                OpenEditSlotDialog(i)
            end
        })
    end

    lib.registerContext({
        id = 'radial_config_menu',
        title = 'Configuración de Radial Menu',
        options = options
    })

    lib.showContext('radial_config_menu')
end

RegisterCommand(Config.OpenSettingsCommand, function()
    OpenRadialConfigMenu()
end, false)