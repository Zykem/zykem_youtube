fx_version 'cerulean'
author 'zykem'
description 'Youtube API'
game 'gta5'

client_scripts {

    'config.lua',
    'client.lua'

}

server_scripts {

    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server.lua'

}

files {

    'handler.html'

}