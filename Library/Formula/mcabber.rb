require 'formula'

class Mcabber < Formula
  homepage 'http://mcabber.com/'
  url 'http://mcabber.com/files/mcabber-0.10.2.tar.bz2'
  sha1 '7bff70dcf09e8a8a4cc7219e03b48bad382a6bda'

  head 'http://mcabber.com/hg/', :using => :hg

  option 'enable-enchant', 'Enable spell checking support via enchant'
  option 'enable-aspell', 'Enable spell checking support via aspell'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'loudmouth'
  depends_on 'gpgme'
  depends_on 'libgcrypt'
  depends_on 'libotr'
  depends_on 'libidn'
  depends_on 'aspell' if build.include? 'enable-aspell'
  depends_on 'enchant' if build.include? 'enable-enchant'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  def install
    if build.head?
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

    args << "--enable-aspell" if build.include? 'enable-aspell'
    args << "--enable-enchant" if build.include? 'enable-enchant'

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
