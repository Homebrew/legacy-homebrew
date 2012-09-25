require 'formula'

class Emacs23Installed < Requirement
  def message; <<-EOS.undent
    Emacs 23 or greater is required to build this software.

    You can install this with Homebrew:
      brew install emacs

    Or you can use any other Emacs distribution
    that provides version 23 or greater.
    EOS
  end
  def satisfied?
    `emacs --version 2>/dev/null` =~ /^GNU Emacs (\d{2})/
    $1.to_i >= 23
  end
  def fatal?
    true
  end
end

class Mu < Formula
  homepage 'http://www.djcbsoftware.nl/code/mu/'
  url 'http://mu0.googlecode.com/files/mu-0.9.8.5.tar.gz'
  sha1 'dfcf1c5ae014f464e083822e3ece420479b64b2a'

  head 'https://github.com/djcb/mu.git'

  option 'with-emacs', 'Build with emacs support'

  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gmime'
  depends_on 'xapian'
  depends_on Emacs23Installed.new if build.include? 'with-emacs'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    # Explicitly tell the build not to include emacs support as the version
    # shipped by default with Mac OS X is too old.
    ENV['EMACS'] = 'no' unless build.include? 'with-emacs'

    system 'autoreconf', '-ivf' if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-gui=none"
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Existing mu users are recommended to run the following after upgrading:

      mu index --rebuild
    EOS
  end
end
