require 'formula'

class Emacs < Formula
  url 'http://ftp.gnu.org/pub/gnu/emacs/emacs-23.3.tar.bz2'
  md5 'a673c163b4714362b94ff6096e4d784a'
  homepage 'http://www.gnu.org/software/emacs/'

  if ARGV.include? "--head-emacs-23"
    head "git://git.savannah.gnu.org/emacs.git", :branch => "emacs-23"
  else
    head "git://git.savannah.gnu.org/emacs.git", :branch => "master"
  end

  def options
    [
      ["--cocoa", "Build a Cocoa version of emacs [excludes --with-x]"],
      ["--with-x", "Include X11 support [excludes --cocoa]"],
      ["--head-emacs-23", "Use official git mirror's emacs-23 branch for HEAD builds"],
    ]
  end

  def patches
    p = [DATA]
    if ARGV.include? "--cocoa" and
        not (ARGV.build_head? and not ARGV.include? "--head-emacs-23")
      "https://github.com/downloads/typester/emacs/feature-fullscreen.patch"
    end
    p
  end

  def caveats
    s = ""
    if ARGV.include? "--cocoa"
      s += <<-EOS.undent
        Emacs.app was installed to:
          #{prefix}

      EOS
    else
      s += <<-EOS.undent
        Use --cocoa to build a Cocoa-specific Emacs.app.

      EOS
    end

    return s
  end

  fails_with_llvm "Duplicate symbol errors while linking."

  def install
    args = ["--prefix=#{prefix}",
            "--without-dbus",
            "--enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp",
            "--infodir=#{info}/emacs"]

    if ARGV.build_head? and File.exists? "./autogen/copy_autogen"
      opoo "Using copy_autogen"
      puts "See https://github.com/mxcl/homebrew/issues/4852"
      system "autogen/copy_autogen"
    end

    if ARGV.include? "--cocoa"
      args << "--with-ns" << "--disable-ns-self-contained"
      system "./configure", *args
      system "make bootstrap"
      system "make install"
      prefix.install "nextstep/Emacs.app"

      bin.mkpath
      ln_s prefix+'Emacs.app/Contents/MacOS/Emacs', bin+'emacs'
      ln_s prefix+'Emacs.app/Contents/MacOS/bin/emacsclient', bin
      ln_s prefix+'Emacs.app/Contents/MacOS/bin/etags', bin
    else
      if ARGV.include? "--with-x"
        args << "--with-x"
        args << "--with-gif=no" << "--with-tiff=no" << "--with-jpeg=no"
      else
        args << "--without-x"
      end

      system "./configure", *args
      system "make"
      system "make install"
    end
  end
end

# patch for color issues described here:
# http://debbugs.gnu.org/cgi/bugreport.cgi?bug=8402
__END__
diff --git a/src/nsterm.m b/src/nsterm.m
index af1f21a..696dbdc 100644
--- a/src/nsterm.m
+++ b/src/nsterm.m
@@ -1389,7 +1389,7 @@ ns_get_color (const char *name, NSColor **col)

   if (r >= 0.0)
     {
-      *col = [NSColor colorWithCalibratedRed: r green: g blue: b alpha: 1.0];
+      *col = [NSColor colorWithDeviceRed: r green: g blue: b alpha: 1.0];
       UNBLOCK_INPUT;
       return 0;
     }
