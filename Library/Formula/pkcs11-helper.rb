class Pkcs11Helper < Formula
  desc "Library to simplify the interaction with PKCS#11"
  homepage "https://github.com/OpenSC/OpenSC/wiki/pkcs11-helper"
  url "https://github.com/OpenSC/pkcs11-helper/archive/pkcs11-helper-1.11.tar.gz"
  sha256 "4b84132efb7685e1ab4dcea953cf88f82a2e6750cbb64a9196fb5acb376c26a4"
  revision 1

  head "https://github.com/OpenSC/pkcs11-helper.git"

  bottle do
    cellar :any
    sha256 "25ef5d225ed45b04ed5cd0d24a028dd9cae1aae1414381043eaccb588f3b5e96" => :el_capitan
    sha256 "97e7c47384dd40ce11a46696e9234c043054681e06f524ff88f9b3e7c3cf57ed" => :yosemite
    sha256 "24bb6ab8aa56792d9b658fa617eef363fc9be794dc3327e5afb88eed30ea8af1" => :mavericks
  end

  option "without-threading", "Build without threading support"
  option "without-slotevent", "Build without slotevent support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-threading" if build.without? "threading"
    args << "--disable-slotevent" if build.without? "slotevent"

    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", *args
    system "make", "install"
  end
end
