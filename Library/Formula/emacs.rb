require 'formula'

class Emacs < Formula
  homepage 'http://www.gnu.org/software/emacs/'
  url 'http://ftpmirror.gnu.org/emacs/emacs-24.3.tar.gz'
  mirror 'http://ftp.gnu.org/pub/gnu/emacs/emacs-24.3.tar.gz'
  sha256 '0098ca3204813d69cd8412045ba33e8701fa2062f4bff56bedafc064979eef41'

  option "cocoa", "Build a Cocoa version of emacs"
  option "srgb", "Enable sRGB colors in the Cocoa version of emacs"
  option "with-x", "Include X11 support"
  option "use-git-head", "Use Savannah (faster) git mirror for HEAD builds"
  option "keep-ctags", "Don't remove the ctags executable that emacs provides"
  option "japanese", "Patch for Japanese input methods"

  head do
    if build.include? "use-git-head"
      url 'http://git.sv.gnu.org/r/emacs.git'
    else
      url 'bzr://http://bzr.savannah.gnu.org/r/emacs/trunk'
    end

    depends_on :autoconf
    depends_on :automake
    depends_on "glib" => :optional
  end

  stable do
    if build.include? "cocoa"
      depends_on :autoconf
      depends_on :automake
    end

    # Fix default-directory on Cocoa and Mavericks.
    # Fixed upstream in r114730 and r114882.
    patch :p0, :DATA

    # Make native fullscreen mode optional, mostly from upstream r111679
    patch do
      url "https://gist.githubusercontent.com/scotchi/7209145/raw/a571acda1c85e13ed8fe8ab7429dcb6cab52344f/ns-use-native-fullscreen-and-toggle-frame-fullscreen.patch"
      sha1 "cb4cc4940efa1a43a5d36ec7b989b90834b7442b"
    end

    # Fix memory leaks in NS version from upstream r114945
    patch do
      url "https://gist.githubusercontent.com/anonymous/8553178/raw/c0ddb67b6e92da35a815d3465c633e036df1a105/emacs.memory.leak.aka.distnoted.patch.diff"
      sha1 "173ce253e0d8920e0aa7b1464d5635f6902c98e7"
    end

    # "--japanese" option:
    # to apply a patch from MacEmacsJP for Japanese input methods
    patch :p0 do
      url "http://sourceforge.jp/projects/macemacsjp/scm/svn/blobs/583/inline_patch/trunk/emacs-inline.patch?export=raw"
      sha1 "61a6f41f3ddc9ecc3d7f57379b3dc195d7b9b5e2"
    end if build.include? "cocoa" and build.include? "japanese"
  end

  depends_on 'pkg-config' => :build
  depends_on :x11 if build.with? "x"
  depends_on "d-bus" => :optional
  depends_on 'gnutls' => :optional
  depends_on "librsvg" => :optional
  depends_on "imagemagick" => :optional
  depends_on "mailutils" => :optional

  fails_with :llvm do
    build 2334
    cause "Duplicate symbol errors while linking."
  end

  # Follow MacPorts and don't install ctags from Emacs. This allows Vim
  # and Emacs and ctags to play together without violence.
  def do_not_install_ctags
    unless build.include? "keep-ctags"
      (bin/"ctags").unlink
      (man1/"ctags.1.gz").unlink
    end
  end

  def install
    # HEAD builds blow up when built in parallel as of April 20 2012
    ENV.deparallelize if build.head?

    args = ["--prefix=#{prefix}",
            "--enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp",
            "--infodir=#{info}/emacs"]
    args << "--with-file-notification=gfile" if build.with? "glib"
    if build.with? "d-bus"
      args << "--with-dbus"
    else
      args << "--without-dbus"
    end
    if build.with? 'gnutls'
      args << '--with-gnutls'
    else
      args << '--without-gnutls'
    end
    args << "--with-rsvg" if build.with? "librsvg"
    args << "--with-imagemagick" if build.with? "imagemagick"
    args << "--without-popmail" if build.with? "mailutils"

    system "./autogen.sh" if build.head?

    if build.include? "cocoa"
      # Patch for color issues described here:
      # http://debbugs.gnu.org/cgi/bugreport.cgi?bug=8402
      if build.include? "srgb" and not build.head?
        inreplace "src/nsterm.m",
          "*col = [NSColor colorWithCalibratedRed: r green: g blue: b alpha: 1.0];",
          "*col = [NSColor colorWithDeviceRed: r green: g blue: b alpha: 1.0];"
      end

      args << "--with-ns" << "--disable-ns-self-contained"
      system "./configure", *args
      system "make"
      system "make install"
      prefix.install "nextstep/Emacs.app"

      # Don't cause ctags clash.
      do_not_install_ctags

      # Replace the symlink with one that avoids starting Cocoa.
      (bin/"emacs").unlink # Kill the existing symlink
      (bin/"emacs").write <<-EOS.undent
        #!/bin/bash
        #{prefix}/Emacs.app/Contents/MacOS/Emacs -nw  "$@"
      EOS
    else
      if build.with? "x"
        # These libs are not specified in xft's .pc. See:
        # https://trac.macports.org/browser/trunk/dports/editors/emacs/Portfile#L74
        # https://github.com/Homebrew/homebrew/issues/8156
        ENV.append 'LDFLAGS', '-lfreetype -lfontconfig'
        args << "--with-x"
        args << "--with-gif=no" << "--with-tiff=no" << "--with-jpeg=no"
      else
        args << "--without-x"
      end

      system "./configure", *args
      system "make"
      system "make install"

      # Don't cause ctags clash.
      do_not_install_ctags
    end
  end

  def caveats
    s = ""
    if build.include? "cocoa"
      s += <<-EOS.undent
        A command line wrapper for the cocoa app was installed to:
         #{bin}/emacs
      EOS
      if build.include? "srgb" and build.head?
        s << "\nTo enable sRGB, use (setq ns-use-srgb-colorspace t)"
      end
    end
    return s
  end

  test do
    assert_equal "4", shell_output("#{bin}/emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end

__END__
--- src/emacs.c.orig	2013-02-06 13:33:36.000000000 +0900
+++ src/emacs.c	2013-11-02 22:38:45.000000000 +0900
@@ -1158,10 +1158,13 @@
   if (!noninteractive)
     {
 #ifdef NS_IMPL_COCOA
+      /* Started from GUI? */
+      /* FIXME: Do the right thing if getenv returns NULL, or if
+         chdir fails.  */
+      if (! inhibit_window_system && ! isatty (0))
+        chdir (getenv ("HOME"));
       if (skip_args < argc)
         {
-	  /* FIXME: Do the right thing if getenv returns NULL, or if
-	     chdir fails.  */
           if (!strncmp (argv[skip_args], "-psn", 4))
             {
               skip_args += 1;
