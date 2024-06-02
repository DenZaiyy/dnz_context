fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'DenZaiyy'
description 'Custom context-menu by DenZaiyy'
version '1.0.0'

dependencies {
    'dnz_fed'
}

-- Shared Scripts
shared_script {
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
    '@oxmysql/lib/MySQL.lua',
    'locales/*.lua',
    'config.lua',
}

-- Client Scripts
client_scripts {
    'client/*.lua',
}

-- Server Scripts
server_scripts {
    'server/*.lua',
}

-- NUI
ui_page 'web/index.html'

files {
    'web/index.html',
    'web/script.js',
}
