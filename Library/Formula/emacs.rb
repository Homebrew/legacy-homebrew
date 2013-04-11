require 'formula'

class Emacs < Formula
  homepage 'http://www.gnu.org/software/emacs/'
  url 'http://ftpmirror.gnu.org/emacs/emacs-24.3.tar.gz'
  mirror 'http://ftp.gnu.org/pub/gnu/emacs/emacs-24.3.tar.gz'
  sha256 '0098ca3204813d69cd8412045ba33e8701fa2062f4bff56bedafc064979eef41'

  option "cocoa", "Build a Cocoa version of emacs"
  option "srgb", "Enable sRGB colors in the Cocoa version of emacs"
  option "with-x", "Include X11 support"
  option "use-git-head", "Use Savannah git mirror for HEAD builds"
  option "keep-ctags", "Don't remove the ctags executable that emacs provides"

  if build.include? "use-git-head"
    head 'http://git.sv.gnu.org/r/emacs.git'
  else
    head 'bzr://http://bzr.savannah.gnu.org/r/emacs/trunk'
  end

  if build.head? or build.include? "cocoa"
    depends_on :autoconf
    depends_on :automake
  end
  depends_on :x11 if build.include? "with-x"

  fails_with :llvm do
    build 2334
    cause "Duplicate symbol errors while linking."
  end

  # Follow MacPorts and don't install ctags from Emacs. This allows Vim
  # and Emacs and ctags to play together without violence.
  def do_not_install_ctags
    unless build.include? "keep-ctags"
      (bin/"ctags").unlink
      (share/man/man1/"ctags.1.gz").unlink
    end
  end

  def install
    # HEAD builds are currently blowing up when built in parallel
    # as of April 20 2012
    ENV.j1 if build.head?

    args = ["--prefix=#{prefix}",
            "--without-dbus",
            "--enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp",
            "--infodir=#{info}/emacs"]

    # See: https://github.com/mxcl/homebrew/issues/4852
    if build.head? and File.exists? "./autogen/copy_autogen"
      system "autogen/copy_autogen"
    end

    if build.include? "cocoa"
      # Patch for color issues described here:
      # http://debbugs.gnu.org/cgi/bugreport.cgi?bug=8402
      if build.include? "srgb"
        inreplace "src/nsterm.m",
          "*col = [NSColor colorWithCalibratedRed: r green: g blue: b alpha: 1.0];",
          "*col = [NSColor colorWithDeviceRed: r green: g blue: b alpha: 1.0];"
      end

      args << "--with-ns" << "--disable-ns-self-contained"
      system "./configure", *args
      system "make bootstrap"
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
      (bin/"emacs").chmod 0755
    else
      if build.include? "with-x"
        # These libs are not specified in xft's .pc. See:
        # https://trac.macports.org/browser/trunk/dports/editors/emacs/Portfile#L74
        # https://github.com/mxcl/homebrew/issues/8156
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
        Emacs.app was installed to:
          #{prefix}

         To link the application to a normal Mac OS X location:
           brew linkapps
         or:
           ln -s #{prefix}/Emacs.app /Applications

         A command line wrapper for the cocoa app was installed to:
          #{bin}/emacs
      EOS
    end

    s += <<-EOS.undent
      Because the official bazaar repository might be slow, we include an option for
      pulling HEAD from an unofficial Git mirror:

        brew install emacs --HEAD --use-git-head

      There is inevitably some lag between checkins made to the official Emacs bazaar
      repository and their appearance on the Savannah mirror. See
      http://git.savannah.gnu.org/cgit/emacs.git for the mirror's status. The Emacs
      devs do not provide support for the git mirror, and they might reject bug
      reports filed with git version information. Use it at your own risk.

      Emacs creates an executable `ctags` that stomps on exuberant-ctags. In
      order to prevent that, we remove `ctags` and its manpage from the emacs
      build before linking. (Add the flag "--keep-ctags" to keep it.) You can
      install exuberant-ctags via brew with `brew install ctags`.
      (exuberant-ctags can provide both vim-style and emacs-style tags.)
    EOS

    return s
  end
end
