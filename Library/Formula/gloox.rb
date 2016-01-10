class Gloox < Formula
  desc "C++ Jabber/XMPP library that handles the low-level protocol"
  homepage "https://camaya.net/gloox/"
  url "https://camaya.net/download/gloox-1.0.14.tar.bz2"
  sha256 "520b72a66fa9fea917a0336872101539f0bea30d1f871e12c31b6c2cd0203941"

  bottle do
    cellar :any
    sha256 "b8f386579b18e8bd114fd6e73d12c375ba90d6a3a29b974e4d665b6a3c546406" => :el_capitan
    sha256 "42999d48ba063b0963e3df47f4b7eda819831d016c2b77e136cc28166c3cf6c9" => :yosemite
    sha256 "1bad7cafd725cfb2c9f8aadd16a75ce450465fa9bcc003283b13f96858b911e9" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "openssl" => :recommended
  depends_on "gnutls" => :optional
  depends_on "libidn" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --with-zlib
      --disable-debug
    ]

    if build.with? "gnutls"
      args << "--with-gnutls=yes"
    else
      args << "--with-openssl=#{Formula["openssl"].opt_prefix}"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"gloox-config", "--cflags", "--libs", "--version"
  end
end
