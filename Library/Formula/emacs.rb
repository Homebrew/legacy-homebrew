require 'formula'

class Emacs < Formula
  homepage 'http://www.gnu.org/software/emacs/'

  if ARGV.include? "--use-git-head"
    head 'git://repo.or.cz/emacs.git'
  elsif ARGV.include? "--use-bzr-head"
    head 'bzr://http://bzr.savannah.gnu.org/r/emacs/trunk'
  else
    url 'http://ftp.gnu.org/pub/gnu/emacs/emacs-23.3.tar.bz2'
    md5 'a673c163b4714362b94ff6096e4d784a'
  end

  def options
    [
      ["--cocoa", "Build a Cocoa version of emacs"],
      ["--with-x", "Include X11 support"],
      ["--use-git-head", "Use repo.or.cz git mirror for HEAD builds"],
      ["--use-bzr-head", "Use official Bazaar repo for HEAD builds."],
    ]
  end

  def patches
    if ARGV.include? "--cocoa" and not ARGV.build_head?
      "https://github.com/downloads/typester/emacs/feature-fullscreen.patch"
    end
  end

  def caveats
    s = ""
    if ARGV.include? "--cocoa"
      s += <<-EOS.undent
        Emacs.app was installed to:
          #{prefix}

      EOS
    else
      if not ARGV.include?("--with-x") and MacOS.x11_installed?
        s += <<-EOS.undent
          X11 is installed and was used for this build.
        EOS
      end
      s += <<-EOS.undent
        Use --cocoa to build a Cocoa-enabled Emacs.app.
      EOS
    end

    if ARGV.include? '--use-bzr-head'
      s += <<-EOS.undent

        The initial checkout of the bazaar Emacs repository might take a long
        time. You might find that using the repo.or.cz git mirror is faster,
        even after the initial checkout. To use the repo.or.cz git mirror for
        HEAD builds, use the --use-git-head option in addition to --HEAD. Note
        that there is inevitably some lag between checkins made to the
        official Emacs bazaar repository and their appearance on the
        repo.or.cz mirror. See http://repo.or.cz/w/emacs.git for the mirror's
        status. The Emacs devs do not provide support for the git mirror, and
        they might reject bug reports filed with git version information. Use
        it at your own risk.
      EOS
    end

    return s
  end

  def install
    fails_with_llvm "Duplicate symbol errors while linking."

    args = ["--prefix=#{prefix}",
            "--enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp",
            "--infodir=#{info}/emacs"]

    if ARGV.include? "--cocoa"
      args << "--with-ns" << "--disable-ns-self-contained"
      system "./configure", *args
      system "make bootstrap"
      system "make install"
      prefix.install "nextstep/Emacs.app"

      bin.mkpath
      ln_s prefix+'Emacs.app/Contents/MacOS/Emacs', bin+'emacs'
      ln_s prefix+'Emacs.app/Contents/MacOS/bin/emacsclient', bin
    else
      if ARGV.include? "--with-x" or MacOS.x11_installed?
        args << "--with-x"
        optional_pkgs = { 'gtk+' => '--with-x-toolkit=gtk' }
        optional_pkgs.each_pair do |pkg, config_opt|
          ohai "#{pkg} is installed, adding #{config_opt}"
          args << config_opt if Formula.factory(pkg).installed?
        end
        checked_pkgs= {
          'giflib' => 'gif',
          'jpeg' => 'jpeg',
          'libtiff' => 'tiff',
          'd-bus' => 'dbus',
        }
        checked_pkgs.each_pair do |pkg, opt|
          use = Formula.factory(pkg).installed? ? "yes" : "no"
          status = Formula.factory(pkg).installed? ? "" : "not "
          ohai "#{pkg} is #{status}installed, adding --with-#{opt}=#{use}"
          args << "--with-#{opt}=#{use}"
        end
      else
        args << "--without-x"
      end

      system "./configure", *args
      system "make"
      system "make install"
    end
  end
end
