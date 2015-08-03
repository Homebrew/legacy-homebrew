class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/archive/pkcs11-helper-1.11.tar.gz"
  sha256 "4b84132efb7685e1ab4dcea953cf88f82a2e6750cbb64a9196fb5acb376c26a4"

  head "https://github.com/OpenSC/pkcs11-helper.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
