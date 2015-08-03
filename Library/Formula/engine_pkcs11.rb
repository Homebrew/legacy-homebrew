class EnginePkcs11 < Formula
  desc "Implementation of OpenSSL engine interface"
  homepage "https://github.com/OpenSC/OpenSC/wiki/OpenSSL-engine-for-PKCS%2311-modules"
  url "https://downloads.sourceforge.net/project/opensc/engine_pkcs11/engine_pkcs11-0.1.8.tar.gz"
  sha256 "de7d7e41e7c42deef40c53e10ccc3f88d2c036d6656ecee7e82e8be07b06a2e5"

  head do
    url "https://github.com/OpenSC/engine_pkcs11.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libp11"
  depends_on "openssl"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
