require 'formula'

class Emacs < Formula
  url 'http://ftp.gnu.org/pub/gnu/emacs/emacs-23.3.tar.bz2'
  md5 'a673c163b4714362b94ff6096e4d784a'
  homepage 'http://www.gnu.org/software/emacs/'

  if ARGV.include? "--use-git-head"
    head 'git://repo.or.cz/emacs.git'
  else
    head 'bzr://http://bzr.savannah.gnu.org/r/emacs/trunk'
  end

  def options
    [
      ["--cocoa", "Build a Cocoa version of emacs"],
      ["--with-x", "Include X11 support"],
      ["--use-git-head", "Use repo.or.cz git mirror for HEAD builds"],
    ]
  end

  def patches
<<<<<<< HEAD
    ps = []
    if ARGV.include? "--cocoa" and not ARGV.build_head?
      ps << "https://github.com/downloads/typester/emacs/feature-fullscreen.patch"
    end
    ps << "https://gist.github.com/raw/959440/127e44bfca90a64396031952c167e039f252f288/gistfile1.diff"
  end
=======
    p = []

    # Fix for building with Xcode 4; harmless on Xcode 3.x.
    unless ARGV.build_head?
      p << "http://repo.or.cz/w/emacs.git/commitdiff_plain/c8bba48c5889c4773c62a10f7c3d4383881f11c1"
    end
>>>>>>> b9741b42a35b676b507cdd2d54b55e374704652e

    if ARGV.include? "--cocoa"
      # Existing fullscreen patch does not patch cleanly against head.
      unless ARGV.build_head?
        p << "https://github.com/downloads/typester/emacs/feature-fullscreen.patch"
      end
    end

    return p
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

  def caveats
    s = "For build options see:\n  brew options emacs\n\n"
    if ARGV.include? "--cocoa"
      s += <<-EOS.undent
        Emacs.app was installed to:
          #{prefix}

      EOS
    end

    s += <<-EOS.undent
      Because the official bazaar repository might be slow, we include an option for
      pulling HEAD from an unofficial Git mirror:

        brew install emacs --HEAD- -use-git-head

      There is inevitably some lag between checkins made to the official Emacs bazaar
      repository and their appearance on the repo.or.cz mirror. See
      http://repo.or.cz/w/emacs.git for the mirror's status. The Emacs devs do not
      provide support for the git mirror, and they might reject bug reports filed
      with git version information. Use it at your own risk.
    EOS

    return s
  end
end
