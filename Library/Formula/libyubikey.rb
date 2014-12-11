require 'formula'

class Libyubikey < Formula
  homepage 'http://yubico.github.io/yubico-c/'
  url 'https://developers.yubico.com/yubico-c/Releases/libyubikey-1.12.tar.gz'
  sha1 '6a73d548e61f0b622a9447917f03c78686ab386d'

  head do
    url 'https://github.com/Yubico/yubico-c.git'
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "asciidoc" => :build
  end

  bottle do
    cellar :any
    revision 1
    sha1 "daad568fcab3dd93b6e04c5f387556d6967c0861" => :yosemite
    sha1 "6180685ff58f83470f2b92ee3537b03c4de6fe96" => :mavericks
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

    if build.head?
      inreplace "Makefile.am",
          "$(A2X) --format=manpage",
          "$(A2X) --format=manpage --no-xmllint"
      system "autoreconf --install"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
