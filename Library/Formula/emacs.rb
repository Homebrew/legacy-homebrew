require 'formula'

class Emacs < Formula
  homepage 'http://www.gnu.org/software/emacs/'
  url 'http://ftpmirror.gnu.org/emacs/emacs-24.1.tar.bz2'
  mirror 'http://ftp.gnu.org/pub/gnu/emacs/emacs-24.1.tar.bz2'
  sha1 'ab22d5bf2072d04faa4aebf819fef3dfe44aacca'

  if ARGV.include? "--use-git-head"
    head 'http://git.sv.gnu.org/r/emacs.git'
  else
    head 'bzr://http://bzr.savannah.gnu.org/r/emacs/trunk'
  end

  # Stripping on Xcode 4 causes malformed object errors.
  # Just skip everything.
  skip_clean :all

  fails_with :llvm do
    build 2334
    cause "Duplicate symbol errors while linking."
  end

  def options
    [
      ["--cocoa", "Build a Cocoa version of emacs"],
      ["--srgb", "Enable sRGB colors in the Cocoa version of emacs"],
      ["--with-x", "Include X11 support"],
      ["--use-git-head", "Use Savannah git mirror for HEAD builds"],
    ]
  end

  def patches
    if ARGV.include? "--cocoa"
      # Fullscreen patch, works against 23.3 and HEAD.
      "https://raw.github.com/gist/1746342/702dfe9e2dd79fddd536aa90d561efdeec2ba716"
    end
  end

  def install
    # HEAD builds are currently blowing up when built in parallel
    # as of April 20 2012
    ENV.j1 if ARGV.build_head?

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
      # Patch for color issues described here:
      # http://debbugs.gnu.org/cgi/bugreport.cgi?bug=8402
      if ARGV.include? "--srgb"
        inreplace "src/nsterm.m",
          "*col = [NSColor colorWithCalibratedRed: r green: g blue: b alpha: 1.0];",
          "*col = [NSColor colorWithDeviceRed: r green: g blue: b alpha: 1.0];"
      end

      args << "--with-ns" << "--disable-ns-self-contained"
      system "./configure", *args
      system "make bootstrap"
      system "make install"
      prefix.install "nextstep/Emacs.app"
    else
      if ARGV.include? "--with-x"
        ENV.x11
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
    end
  end

  def caveats
    s = ""
    if ARGV.include? "--cocoa"
      s += <<-EOS.undent
        Emacs.app was installed to:
          #{prefix}

        Command-line emacs can be used by setting up an alias:
          alias emacs="#{prefix}/Emacs.app/Contents/MacOS/Emacs -nw"

         To link the application to a normal Mac OS X location:
           brew linkapps
         or:
           ln -s #{prefix}/Emacs.app /Applications

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
    EOS

    return s
  end
end
