rm -rf LuaDoTheWorld
rm -rf candangoEngine
git clone -b v0.71 https://github.com/OUIsolutions/LuaDoTheWorld.git
git clone -b V0.001 https://github.com/SamuelHenriqueDeMoraisVitrio/candangoEngine.git
curl -L https://github.com/OUIsolutions/Darwin/releases/download/0.011/darwin011.c -o darwin011.c
curl -L https://github.com/OUIsolutions/LuaCEmbed/releases/download/v0.778/LuaCEmbed.h -o assets/LuaCEmbed.h