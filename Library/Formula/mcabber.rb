require 'formula'

class Mcabber < Formula
  homepage 'http://mcabber.com/'
  url 'http://mcabber.com/files/mcabber-0.10.1.tar.bz2'
  md5 'fe96beab30f535d5d6270fd1719659b4'

  head 'http://mcabber.com/hg/', :using => :hg

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'loudmouth'
  depends_on 'gpgme'
  depends_on 'libgcrypt'
  depends_on 'libotr'
  depends_on 'libidn'
  depends_on 'aspell' if ARGV.include? '--enable-aspell'
  depends_on 'enchant' if ARGV.include? '--enable-enchant'

  if ARGV.build_head?
    depends_on :automake
    depends_on :libtool
  end

  def options
    [
      ["--enable-enchant", "Enable spell checking support via enchant"],
      ["--enable-aspell", "Enable spell checking support via aspell"],
    ]
  end

  def install
    if ARGV.build_head? then
      ENV['LIBTOOLIZE'] = 'glibtoolize'
      ENV['ACLOCAL'] = "aclocal -I #{HOMEBREW_PREFIX}/share/aclocal"
      cd 'mcabber' # Not using block form on purpose
      inreplace 'autogen.sh', 'libtoolize', '$LIBTOOLIZE'
      inreplace 'autogen.sh', 'aclocal', '$ACLOCAL'
      system "./autogen.sh"
    end

    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--enable-otr"]

    args << "--enable-aspell" if ARGV.include? "--enable-aspell"
    args << "--enable-enchant" if ARGV.include? "--enable-enchant"

    system "./configure", *args
    system "make install"

    (share+'mcabber').install %w[mcabberrc.example contrib]
  end

  def caveats; <<-EOS.undent
    A configuration file is necessary to start mcabber.  The template is here:
      #{share}/mcabber/mcabberrc.example
    And there is a Getting Started Guide you will need to setup Mcabber:
      http://wiki.mcabber.com/index.php/Getting_started
    EOS
  end
end
