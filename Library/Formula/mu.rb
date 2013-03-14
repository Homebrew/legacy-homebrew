require 'formula'

class Emacs23Installed < Requirement
  fatal true
  env :userpaths

  satisfy do
    `emacs --version 2>/dev/null` =~ /^GNU Emacs (\d{2})/
    $1.to_i >= 23
  end

  def message; <<-EOS.undent
    Emacs 23 or greater is required to build this software.

    You can install this with Homebrew:
      brew install emacs

    Or you can use any other Emacs distribution
    that provides version 23 or greater.
    EOS
  end
end

class Mu < Formula
  homepage 'http://www.djcbsoftware.nl/code/mu/'
  url 'http://mu0.googlecode.com/files/mu-0.9.9.tar.gz'
  sha1 'eafd678faf852230f55ae262ae005d006a9a839b'

  head 'https://github.com/djcb/mu.git'

  option 'with-emacs', 'Build with emacs support'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gmime'
  depends_on 'xapian'
  depends_on Emacs23Installed if build.include? 'with-emacs'

  if build.head?
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
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
