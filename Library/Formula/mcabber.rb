require 'formula'

class Mcabber < Formula
  homepage 'http://mcabber.com/'
  url 'http://mcabber.com/files/mcabber-0.10.3.tar.bz2'
  sha1 '9254f520cb37e691fb55d4fc46df4440e4a17f14'

  head do
    url 'http://mcabber.com/hg/', :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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

  def install
    if build.head?
      cd "mcabber"
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
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
