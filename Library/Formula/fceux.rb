require 'formula'

class Fceux < Formula
  url 'http://downloads.sourceforge.net/fceultra/fceux-2.1.5.src.tar.bz2'
  homepage 'http://fceux.com'
  md5 'e8b20e62bbbb061b1a59d51b47c827bd'
  
  depends_on 'scons'
  depends_on 'sdl'
  depends_on 'libzip'
  depends_on 'gtk+' unless ARGV.include? "--no-gtk"

  def options
    [
      ['--no-gtk', "Don't build with Gtk+ support"]
    ]
  end
  
  def patches
    # fixes compilation errors on osx -- patch data at tail
    DATA
  end

  def install
    if ARGV.include? "--no-gtk"
      system "sed \"s/\\(GTK.\\+ \\)1/\\10/g\" SConstruct > SConstruct"
    end
    system "scons"
	bin.install '/src/fceux'
	chmod 0755, bin+'fceux'
  end
end

### patch data
__END__
t a/src/drivers/sdl/SConscript b/src/drivers/sdl/SConscript
index 9c7247c..7a9f297 100644
--- a/src/drivers/sdl/SConscript
+++ b/src/drivers/sdl/SConscript
@@ -1,3 +1,6 @@
+Import('env')
+env.ParseConfig('pkg-config --cflags --libs x11')
+Export('env')
 my_list =  Split("""
 input.cpp
 config.cpp
# config.cpp
