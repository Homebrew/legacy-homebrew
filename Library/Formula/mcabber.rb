class Mcabber < Formula
  desc "Console Jabber client"
  homepage "https://mcabber.com/"
  url "https://lilotux.net/~mikael/mcabber/files/mcabber-1.0.1.tar.bz2"
  sha256 "579a45a2bc944455012ca9b308f7f3454efabbe0c36c6723af761aa1f3092d93"

  bottle do
    sha256 "d1a3153df34801476d80b8ee36c3a04d6b96906890be7d13a9a03da502001292" => :yosemite
    sha256 "bea407be11ef8b7a078c07a23f43e7141618f8a72902cc2573dbda53e1a862ba" => :mavericks
    sha256 "eb37bcb8e3352a76e65b48b2f342f04131a0a60a69472f83e573c14755eb84ad" => :mountain_lion
  end

  head do
    url "http://mcabber.com/hg/", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  deprecated_option "enable-aspell" => "with-aspell"
  deprecated_option "enable-enchant" => "with-enchant"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "loudmouth"
  depends_on "gpgme"
  depends_on "libgcrypt"
  depends_on "libotr"
  depends_on "libidn"
  depends_on "aspell" => :optional
  depends_on "enchant" => :optional

  def install
    if build.head?
      cd "mcabber"
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh"
    end

    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--enable-otr"]

    args << "--enable-aspell" if build.with? "aspell"
    args << "--enable-enchant" if build.with? "enchant"

    system "./configure", *args
    system "make", "install"

    (share+"mcabber").install %w[mcabberrc.example contrib]
  end

  def caveats; <<-EOS.undent
    A configuration file is necessary to start mcabber.  The template is here:
      #{share}/mcabber/mcabberrc.example
    And there is a Getting Started Guide you will need to setup Mcabber:
      http://wiki.mcabber.com/index.php/Getting_started
    EOS
  end
end
