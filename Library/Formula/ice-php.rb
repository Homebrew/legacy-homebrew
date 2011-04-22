require 'formula'

class IcePhp < Formula
  url 'http://www.zeroc.com/download/Ice/3.4/Ice-3.4.1.tar.gz'
  homepage 'http://www.zeroc.com'
  md5 '3aae42aa47dec74bb258c1a1b2847a1a'

  depends_on 'ice'

  def patches
    "Allow compile php extension in Mac OS."
    "http://www.zeroc.com/forums/help-center/5053-ice-3-4-1-php-mac-os-snow-leopard.html#post22291"
    DATA
  end

  def install
    ENV.O2
    ENV.append "ICE_HOME", "#{HOMEBREW_PREFIX}/Cellar/ice/3.4.1"
    ENV.append "PHP_HOME", "/usr"

    system "cp", "cpp/config/Make.rules.Darwin", "php/config/"
    inreplace "php/config/Make.rules.php" do |s|
      s.gsub! "#OPTIMIZE", "OPTIMIZE"
      s.gsub! "/opt/Ice-$(VERSION)", "#{prefix}"
      s.gsub! "/opt/Ice-$(VERSION_MAJOR).$(VERSION_MINOR)", "#{prefix}"
    end

    inreplace "php/config/Make.rules.Darwin" do |s|
      s.change_make_var! "CXXFLAGS", "#{ENV.cflags} -Wall -D_REENTRANT"
    end

    Dir.chdir "php" do
      system "make"
      system "make install"
    end

    system "ln -s #{prefix}/php/IcePHP.dy #{prefix}/php/IcePHP.so"


  end

  def caveats; <<-EOS.undent
    * Open your php.ini and append the following lines:

      ; appand extension path
      extensioni_dir = "#{prefix}/php"

      ; load extension
      extension = IcePHP.so

      ; allow to include Ice depends. Sample Ice.php
      include_path = "#{prefix}/php"
<<<<<<< HEAD
      
=======
>>>>>>> f653cb35288baa4be773d604971570a6bdc00e83
    EOS
  end

end

__END__
diff --git a/cpp/config/Make.rules.Darwin.ori b/cpp/config/Make.rules.Darwin
index 766165d..e71a3b8 100644
--- ./cpp/config/Make.rules.Darwin.ori
+++ ./cpp/config/Make.rules.Darwin
@@ -35,13 +35,9 @@ ifneq ($(embedded_runpath_prefix),)
     endif
 endif
 
-LDPLATFORMFLAGS		+= -rdynamic
+LDPLATFORMFLAGS		= -Wl,-bind_at_load
 
-ifdef ice_src_dist
-    shlibldflags	= $(CXXFLAGS) -L$(libdir)
-else
-    shlibldflags	= $(CXXFLAGS) -L$(ice_dir)/$(libsubdir)
-endif
+shlibldflags  = $(CXXFLAGS) ${wl}-flat_namespace ${wl}-undefined ${wl}suppress -L$(libdir)
 
 mklibfilename       	= $(if $(2),lib$(1).$(2).dylib,lib$(1).dylib)
 mksoname           	= $(if $(2),lib$(1).$(2).dylib,lib$(1).dylib)
