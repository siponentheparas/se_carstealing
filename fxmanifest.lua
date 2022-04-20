fx_version 'cerulean'
game 'gta5'

author 'seikkailija007'
version '1.0.0'

client_script 'client/main.lua'

server_scripts {
    'server/main.lua',
    '@mysql-async/lib/MySQL.lua'
} 

shared_script 'config.lua'