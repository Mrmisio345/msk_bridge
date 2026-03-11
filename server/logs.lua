local IdentifiersCache <const>, Logs <const> = {}, require 'data.logs'
local function GetIdentifiers(playerId)
    if not playerId then
        return {
            steam = 'not found',
            license = 'not found',
            discord = 'not found',
            fivem = 'not found',
        }
    end

    if IdentifiersCache[playerId] then
        return IdentifiersCache[playerId]
    end

    local identifiers <const> = {
        steam = 'not found',
        license = 'not found',
        discord = 'not found',
        fivem = 'not found',
    }

    local playerIdentifiers = GetPlayerIdentifiers(playerId)
    if playerIdentifiers then
        for _, v in ipairs(playerIdentifiers) do
            if string.match(v, 'steam:') then
                identifiers.steam = v
            elseif string.match(v, 'license:') then
                identifiers.license = v
            elseif string.match(v, 'discord:') then
                identifiers.discord = v
            elseif string.match(v, 'fivem:') then
                identifiers.fivem = v
            end
        end
    end

    IdentifiersCache[playerId] = identifiers
    return identifiers
end

local function ClearIdentifierCache(playerId)
    IdentifiersCache[playerId] = nil
end

local function FormatPlayerInfo(playerId)
    if not playerId then
        return ''
    end

    if type(playerId) == 'table' then
        if playerId.identifier then
            return 'Identifier: ' .. playerId.identifier .. ' '
        end

        if playerId.charid then
            return 'CharID: ' .. playerId.charid .. ' '
        end

        return ''
    end

    local playerName <const> = GetPlayerName(playerId) or 'Unknown'
    local ids <const> = GetIdentifiers(playerId)

    return string.format(
        '[ID: %d] - %s\nSteam: %s\nLicense: %s\nDiscord: %s',
        playerId,
        playerName,
        ids.steam,
        ids.license,
        ids.discord
    )
end

local function SendToWebhook(webhook, data)
    if not webhook or webhook == '' then
        return
    end

    local embeds <const> = {
        {
            color = 0x049CEF,
            author = {
                name = 'MSK Scripts • Logs',
                icon_url = 'https://upload.peakrp.pl/static/msk_logo.png',
            },

            title = '📋  ' .. string.upper(data.name or 'LOG'),
            description = data.message or '',
            fields = {},
            thumbnail = {
                url = 'https://upload.peakrp.pl/static/msk_logo.png',
            },

            image = {
                url = data.photo or '',
            },

            footer = {
                text = '🕐 MSK Scripts • ' .. os.date('%d.%m.%Y • %H:%M:%S'),
                icon_url = 'https://upload.peakrp.pl/static/msk_logo.png',
            },

            timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ'),
        }
    }

    if data.player and data.player ~= '' then
        table.insert(embeds[1].fields, {
            name = '👤 Player',
            value = '```\n' .. data.player .. '\n```',
            inline = true,
        })
    end

    if data.target and data.target ~= '' then
        table.insert(embeds[1].fields, {
            name = '🎯 Target',
            value = '```\n' .. data.target .. '\n```',
            inline = true,
        })
    end

    PerformHttpRequest(webhook, function(err)
        if err ~= 200 and err ~= 204 then
            print(('[msk_bridge] [logs] Webhook error: %s for log: %s'):format(tostring(err), data.name or 'Unknown'))
        end
    end, 'POST', json.encode({
        username = 'MSK Scripts Logs',
        avatar_url = 'https://upload.peakrp.pl/static/msk.png',
        embeds = embeds,
    }), { ['Content-Type'] = 'application/json' })
end

SendLog = function(name, player, target, message, photo)
    if not name then
        return
    end

    local webhook <const> = Logs[name]
    if not webhook or webhook == '' then
        print(('[msk_bridge] [logs] No webhook configured for: %s'):format(name))
        return
    end

    local data = {
        name = name,
        player = FormatPlayerInfo(player),
        target = FormatPlayerInfo(target),
        message = message or '',
        photo = photo,
    }

    SendToWebhook(webhook, data)
end

return {
    SendLog = SendLog,
    ClearIdentifierCache = ClearIdentifierCache,
}