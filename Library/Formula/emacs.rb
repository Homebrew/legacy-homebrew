require 'formula'

class Magit <Formula
  url 'http://zagadka.vm.bytemark.co.uk/magit/magit-0.7.tar.gz'
  md5 '1ea442bd6f83f7ac82967059754c8c87'
  homepage 'http://zagadka.vm.bytemark.co.uk/magit/'
end

class Emacs <Formula
  url 'http://ftp.gnu.org/pub/gnu/emacs/emacs-23.2.tar.bz2'
  md5 '057a0379f2f6b85fb114d8c723c79ce2'
  if ARGV.include? "--use-git-head"
    head 'git://repo.or.cz/emacs.git'
  else
    head 'bzr://http://bzr.savannah.gnu.org/r/emacs/trunk'
  end
  homepage 'http://www.gnu.org/software/emacs/'

  def options
    [
      ["--cocoa", "Build a Cocoa version of emacs"],
      ["--use-git-head", "Use repo.or.cz git mirror for HEAD builds"],
    ]
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

    s += <<-EOS.undent
      To access texinfo documentation, set your INFOPATH to:
        #{info}

      The Emacs project now uses bazaar for source code versioning. If you
      last built the Homebrew emacs formula from HEAD prior to their switch
      from CVS to bazaar, you will have to remove Homebrew's cached download
      before building from HEAD again:
        #{HOMEBREW_CACHE}/emacs-HEAD

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

      If you switch between repositories, you'll have to remove the Homebrew
      emacs cache directory (see above).
    EOS

    return s
  end
  
  def install
    configure_args = [
      "--prefix=#{prefix}",
      "--without-dbus",
      "--enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp",
    ]

    if ARGV.include? "--cocoa"
      configure_args << "--with-ns" << "--disable-ns-self-contained"
      system "./configure", *configure_args
      system "make bootstrap"
      system "make install"
      prefix.install "nextstep/Emacs.app"
    else
      configure_args << "--without-x"
      system "./configure", *configure_args
      system "make"
      system "make install"
    end

    Magit.new.brew do
      system "./configure", "--prefix=#{prefix}"
      system "make install"
    end
  end
end
