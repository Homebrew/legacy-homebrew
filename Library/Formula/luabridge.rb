
class Luabridge < Formula
  homepage "https://github.com/vinniefalco/LuaBridge"

  stable do
    url "https://github.com/vinniefalco/LuaBridge.git", :revision => "04b47d723d35b47ff8efce63d54ef264a59152b5"
    version "2.0"

    # Fix error: no matching function for call to 'lua_pushstring'
    # https://github.com/vinniefalco/LuaBridge/pull/83
    patch :DATA
  end

  head "https://github.com/vinniefalco/LuaBridge.git", :branch => "develop"

  depends_on "lua"

  def install
    include.install "Source/LuaBridge"
  end

  test do
    (testpath/'test.cpp').write <<-EOS.undent
      #include <lua.hpp>
      #include <LuaBridge/LuaBridge.h>
      #include <iostream>

      void sayNumber(int i)
      {
        std::cout << "number is: " << i << std::endl;
      }

      int main() {
        using namespace luabridge;

        lua_State* L = luaL_newstate();
        luaL_openlibs(L);

        getGlobalNamespace(L)
          .addFunction("sayNumber", sayNumber);

        luaL_dofile(L, "script.lua");
        lua_pcall(L, 0, 0, 0);

        LuaRef s = getGlobal(L, "testString");
        std::string luaString = s.cast<std::string>();

        return 0;
      }
    EOS

    (testpath/'script.lua').write <<-EOS.undent
      sayNumber(10)
      testString = "LuaBridge works!"
    EOS

    system ENV.cxx, "test.cpp", "-llua", "-o", "test"
    system "./test"

  end
end
__END__
--- a/Source/LuaBridge/detail/Stack.h
+++ b/Source/LuaBridge/detail/Stack.h
@@ -457,7 +457,7 @@ struct Stack <std::string const&>
 {
   static inline void push (lua_State* L, std::string const& str)
   {
-    lua_pushstring (L, str.c_str(), str.size());
+    lua_pushlstring (L, str.c_str(), str.size());
   }
 
   static inline std::string get (lua_State* L, int index)

