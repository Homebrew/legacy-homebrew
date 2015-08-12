class Mcabber < Formula
  desc "Console Jabber client"
  homepage "https://mcabber.com/"
  url "https://lilotux.net/~mikael/mcabber/files/mcabber-1.0.1.tar.bz2"
  sha256 "579a45a2bc944455012ca9b308f7f3454efabbe0c36c6723af761aa1f3092d93"

  bottle do
    sha256 "f582dc53fe2e9b1f317885d069ccc1b5ebea671f992bd373223a2d37c998ba23" => :el_capitan
    sha256 "9077d7c748da6ef614f8f0a7c472c32dd9b529c3f759645439f90436215650a5" => :yosemite
    sha256 "e962fc94951c93707b969f23490407d09effab4637903f88d91347428b125e52" => :mavericks
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
