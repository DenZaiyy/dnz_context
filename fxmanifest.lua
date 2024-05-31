fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'DenZaiyy'
description ''
version '1.0.0'

-- Shared Scripts
shared_script {
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
    'locales/*.lua',
    'config.lua',
}

-- Client Scripts
client_scripts {
    'client/client.lua',
}

-- Server Scripts
server_scripts {
    'server/server.lua',
}

-- NUI
ui_page 'web/index.html'

files {
    'web/index.html'
}
