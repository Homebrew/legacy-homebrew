require 'formula'

class Uci < Formula
  homepage 'http://wiki.openwrt.org/doc/techref/uci'
  head 'git://nbd.name/uci.git'

  def options
    [
      ["--uci-debug", "Enable debugging"],
      ["--uci-debug-typecast", "Enable typecast debugging"],
      ["--plugin-support", "Plugin support"],
      ["--lua", "LUA plugin"]
    ]
  end

  depends_on 'cmake' => :build
  depends_on 'lua' if ARGV.include? "--lua"

  def patches
    # Strange CMAKE_INSTALL_PREFIX fixed in CMakeLists.txt
    DATA
  end

  def install
    args = ["."] + std_cmake_parameters.split
    args << "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
    args << "-DCMAKE_INSTALL_RPATH=#{prefix}/lib"
    args << "-DCMAKE_INSTALL_NAME_DIR=#{prefix}/lib"
    args << "-DUCI_DEBUG=ON" if ARGV.include? "--uci-debug"
    args << "-DDEBUG=1" if ARGV.include? "--uci-debug"
    args << "-DUCI_DEBUG_TYPECAST=ON" if ARGV.include? "--uci-debug-typecast"

    if ARGV.include? "--plugin-support" or ARGV.include? "--lua"
      args << "-DUCI_PLUGIN_SUPPORT=ON"
    else
      args << "-DUCI_PLUGIN_SUPPORT=OFF"
    end

    if ARGV.include? "--lua"
      args << "-DBUILD_LUA=ON"
    else
      args << "-DBUILD_LUA=OFF"
    end

    system "cmake", *args
    system "make install"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 54c5cf2..60188f8 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -2,8 +2,6 @@ cmake_minimum_required(VERSION 2.6)
 
 PROJECT(uci C)
 
-SET(CMAKE_INSTALL_PREFIX /usr)
-
 ADD_DEFINITIONS(-Os -Wall -Werror --std=gnu99 -g3 -I. -DUCI_PREFIX="${CMAKE_INSTALL_PREFIX}")
 
 OPTION(UCI_PLUGIN_SUPPORT "plugin support" ON)

