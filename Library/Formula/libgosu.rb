require "formula"

# libgosu has four different build systems:
#  - Ruby gem
#  - Linux cmake (.so)
#  - Mac CocoaPods (statically linked)
#  - Windows MSVC (statically linked)
#
# Thus, the only way to build a cross-platform C++ libgosu app is to include
# libgosu source in your project's source.  This, however, defeats the point of
# a package manager.
#
# This formula attempts to add a fifth build system: a .dylib for Mac.  This
# unifies the linking process on Linux and Mac and would theoretically allow
# one to compile Linux-based libgosu projects on Mac.
#
# TODO: include gosu.pc for pkg-config

class Libgosu < Formula
  homepage 'http://libgosu.org'
  url 'https://github.com/jlnr/gosu/archive/v0.8.5.tar.gz'
  sha1 '516c4e21a00402c1dbd99d372db127a54d2bc4e0'

  head 'https://github.com/jlnr/gosu.git'

  depends_on 'sdl2'
  depends_on 'libogg'
  depends_on 'libvorbis'

  def install
    # libgosu does not officially support building a .dylib on Mac.  We will
    # hack a .dylib build on top of its gem build because that already supports
    # native Mac builds.
    #
    # Also, make install is incomplete for gem builds.  Do our own install.
    cd "ext/gosu" do
      system "ruby", "extconf.rb"
      inreplace "Makefile" do |s|
        # Build native instead of forcing i386.
        s.gsub! "-arch i386", ""
        # Gosu's gem build makes a .bundle, but let's make a .dylib.
        s.gsub! "-dynamic -bundle", "-dynamiclib"
        # Call it libgosu.dylib instead of gosu.dylib
        s.gsub! "$(TARGET).bundle", "lib$(TARGET).dylib"
      end
      system "make"
      lib.install "libgosu.dylib"
    end
    include.install "Gosu"
  end

  test do
    Pathname("test.cpp").write <<-EOS.undent
      #include <Gosu/Gosu.hpp>

      class MyWindow : public Gosu::Window
      {
      public:
          MyWindow()
          :   Gosu::Window(640, 480, false)
          {
              setCaption(L\"Hello World!\");
          }
      };

      int main()
      {
          MyWindow window;
          window.show();
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgosu", "-I#{include}", "-std=c++11"
  end
end
