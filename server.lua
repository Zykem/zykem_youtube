local DISCORD_WEBHOOK = 'https://discord.com/api/webhooks/'
local APIKEY = "apikey"


function discordLog(source,text)
    local _source = source
    local embed = {}
    local profile = "[" .. _source .. '] # ' .. GetPlayerName(_source) .. ' |'
    embed = {
        {
            ['color'] = 5793266,
            ["title"] = "Youtube API Logs",
            ["description"] = profile .. text,
            ['footer'] = {
                ['text'] = os.date() .. " | Youtube API"
            },
        }
    }
    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = 'Youtube API Logs', embeds = embed}), { ['Content-Type'] = 'application/json' })

end

CreateThread(function()

    if cfg.useFramework then
        ESX = nil

        TriggerEvent(cfg.frameworkInit, function(obj) ESX = obj end)
    end

end)

local api = {

    parsevidID = function(url)

        return string.match(url, "%?v=(.-)&")

    end,

    isVideoUsed = function(videoid) 
        local used
        MySQL.Async.fetchAll('SELECT * FROM users WHERE videoid = @videoid', {
    
            ['@videoid'] = videoid
    
        }, function(result)
            if result[1] ~= nil then 
                used = true
            else
                used = false
            end
        
        end)
        while used == nil do Wait(50) end;
        return used;
    end,

    checkVideos = function()
        MySQL.Async.fetchAll('SELECT videoid,identifier FROM users', {}, function(result)
            for i=1,#result, 1 do
    
                PerformHttpRequest('https://www.googleapis.com/youtube/v3/videos?id=' .. result[i].videoid .. '&part=status&key=' .. APIKEY, function(err,text,headers) 
                    local response = json.decode(text)
                    if(#response['items'] <= 0) then
    
                        prompt('console', 'Deleted ' .. result[i].identifier .. ' from DB\nReason: Video Deleted')
                        deleteYoutuber(result[i].identifier)
    
                    else
                        for k,v in pairs(response['items']) do
                            if(v.status.privacyStatus == 'unlisted') then
                                deleteYoutuber(result[i].identifier)
                                prompt('console', 'Deleted ' .. result[i].identifier .. ' from DB\nReason: Video Unlisted')
                            end
                        end
                    end 
    
                end)
      
    
            end
        
        end)
    end,

    fetchVideoData = function(videoId)
        videodata = nil
        PerformHttpRequest('https://www.googleapis.com/youtube/v3/videos?part=snippet&id=' .. videoId .. '&key=AIzaSyALUr2kKDAWrK3RGPFTMHSkFPDDi3sS0Ks', function(err,text,headers)
            local response = json.decode(text)
            
            for k,v in pairs(response['items']) do
    
                videodata = {title = v.snippet.title, subs = getSubCount(v.snippet.channelId), desc = v.snippet.description}
    
            end
            
        end)
        while videodata == nil do Wait(50) end;
        return videodata
    
    end,

    getVideoStatus = function(videoId)
        local status = nil
        PerformHttpRequest('https://www.googleapis.com/youtube/v3/videos?id=' .. videoId .. '&part=status&key=' .. APIKEY, function(err,text,headers) 
            local response = json.decode(text)
    
            for k,v in pairs(response['items']) do
                status = v.status.privacyStatus
            end 
    
        end)
        while status == nil do Wait(50) end;
        return status
    end,

    getVideoDuration = function(videoId)
        local duration = nil
        PerformHttpRequest('https://www.googleapis.com/youtube/v3/videos?id=' .. videoId .. '&part=contentDetails&key=' .. APIKEY, function(err,text,headers) 
            local response = json.decode(text)
            
            for k,v in pairs(response['items']) do
                duration = v.contentDetails.duration
            end
            
        end)
        while duration == nil do Wait(50) end;
        return duration
    end,

    getSubCount = function(channelId)
        local subs = nil
        PerformHttpRequest(cfg.youtube.yt_baseUrl .. 'part=statistics&id=' .. channelId .. '&key=' .. APIKEY, function(err,text,headers) 
           local response = json.decode(text)
           
           for k,v in pairs(response['items']) do
               subs = v.statistics.subscriberCount
           end
           
       end)
       while subs == nil do Wait(50) end;
       return subs
    end,
    parseISODate = function(str)
        local formatted_date = os.date()
    end
}

deleteYoutuber = function(identifier)
    MySQL.Async.execute("UPDATE users SET rank = @rank WHERE identifier = @identifier AND rank = @ranga",{
        ['@identifier'] = identifier,
        ['@rank'] = 'Gracz',
        ['@ranga'] = 'youtuber'
    }, function(result)
        
        
    
    end)
end

function prompt(type,msg)
    
    if type ~= 'title' or type ~= 'desc' or type ~= 'subs' or type ~= 'duration' or type ~= 'status' or type ~= 'used' or type ~= 'ytalready' or type ~= 'console' then return end;
    if type == 'title' then TriggerClientEvent('zykem_misc:notify', source, cfg.locales[cfg.lang].wrongtitle) return end;
    if type == 'desc' then TriggerClientEvent('zykem_misc:notify', source, cfg.locales[cfg.lang].wrongdesc) return end;
    if type == 'subs' then TriggerClientEvent('zykem_misc:notify', source, cfg.locales[cfg.lang].subs) return end;
    if type == 'duration' then TriggerClientEvent('zykem_misc:notify', source, cfg.locales[cfg.lang].wrongduration) return end;
    if type == 'status' then TriggerClientEvent('zykem_misc:notify', source, cfg.locales[cfg.lang].status) return end;
    if type == 'used' then TriggerClientEvent('zykem_misc:notify', source, cfg.locales[cfg.lang].used) return end;
    if type == 'ytalready' then TriggerClientEvent('zykem_misc:notify', source, cfg.locales[cfg.lang].ytalready) return end;
    if type == 'console' then print('[YoutubeAPI] # ' .. msg) end;

end

RegisterCommand("duration", function(source, args,raw)

    if args[1] ~= nil then

        local videoID = api.parsevidID(args[1])
        local duration = api.getVideoDuration(videoID)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.showNotification(cfg.locales[cfg.lang].videoduration .. duration)

    end

end)

if ESX ~= nil then
    ESX.RegisterServerCallback('zykem_youtube:redeemRank', function(source,cb,videoURL)
        if ESX ~= nil then
            local xPlayer = ESX.GetPlayerFromId(source)
            local identifier = xPlayer.getIdentifier();
            videoid = api.parsevidID(videoURL)
    
            if rank.getRank(identifier) == 'youtuber' then prompt(source, 'ytalready') return end;
            if api.isVideoUsed(videoid) then prompt(source, 'used') return end;
    
            TriggerClientEvent('zykem_misc:notify', source, cfg.locales[cfg.lang].fetching)
            local videodata = api.fetchVideoData(videoid);
            local videoduration = api.getVideoDuration(videoid);
            local status = api.getVideoStatus(videoid);
            -- checks
            if status ~= 'public' then wrongVideo(source, 'status') return end;
            if tonumber(videodata.subs) < cfg.requirements.subs then wrongVideo(source, 'subs') return end;
            if videodata.title ~= cfg.requirements.video_title then wrongVideo(source, 'title') return end;
            if videodata.desc ~= cfg.requirements.video_desc then wrongVideo(source, 'desc') return end;
            if videoduration ~= cfg.requirements.duration then wrongVideo(source, 'duration') return end;
            -- success update
            ranks.updateRank(identifier, GetPlayerName(source), videoid, 'youtuber')
            TriggerClientEvent('zykem_misc:notify', source, cfg.locales[cfg.lang].success)
        end
    end)
else
    RegisterServerEvent('zykem_youtube:redeemRank', function(videoURL)
        local _source = source
        -- Standalone rewarding event
        local identifier = nil
        for k,v in pairs(GetPlayerIdentifiers(source)) do

            if string.sub(v,1,string.len("license:")) == "license:" then
                idenitifier = v
            end

        end
        while identifier == nil do Wait(10) end;
        videoid = api.parsevidID(videoURL)
    
        if rank.getRank(identifier) == 'youtuber' then prompt(source, 'ytalready') return end;
        if api.isVideoUsed(videoid) then prompt(source, 'used') return end;

        TriggerClientEvent('zykem_misc:notify', source, cfg.locales[cfg.lang].fetching)
        local videodata = api.fetchVideoData(videoid);
        local videoduration = api.getVideoDuration(videoid);
        local status = api.getVideoStatus(videoid);
        -- checks
        if status ~= 'public' then wrongVideo(source, 'status') return end;
        if tonumber(videodata.subs) < cfg.requirements.subs then wrongVideo(source, 'subs') return end;
        if videodata.title ~= cfg.requirements.video_title then wrongVideo(source, 'title') return end;
        if videodata.desc ~= cfg.requirements.video_desc then wrongVideo(source, 'desc') return end;
        if videoduration ~= cfg.requirements.duration then wrongVideo(source, 'duration') return end;
        -- success update
        ranks.updateRank(identifier, GetPlayerName(source), videoid, 'youtuber')
        TriggerClientEvent('zykem_misc:notify', source, cfg.locales[cfg.lang].success)
    
    end)
end


CreateThread(function()

    while true do
        api.checkVideos()
        Citizen.Wait(1000 * 60 * 3)
    end
    
end)
