fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Misiaczek | https://github.com/Mrmisio345'
version '1.2'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

ui_page 'ui/dist/index.html'

files {
	'ui/dist/**/*.*',
	'ui/dist/*.html',
    'data/*.*',
    
    -- client_scripts
    'framework/client/*.*',
    'target/*.*',

    -- server_scripts
    'framework/server/*.*',
    'server/logs.lua',

    -- modules
    'modules/*.*',

    -- shared_scripts
    'shared/loader.lua',
    'shared/utils.lua',
}

