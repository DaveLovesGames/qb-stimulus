fx_version 'cerulean'
game 'gta5'

author 'DaveLovesGames'
description 'QB-Core Stimulus Payment System'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

client_scripts {
    'client/client.lua'
}

lua54 'yes' 