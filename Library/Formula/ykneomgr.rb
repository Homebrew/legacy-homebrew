class Ykneomgr < Formula
  desc "CLI and C library to interact with the CCID-part of the YubiKey NEO"
  homepage "https://developers.yubico.com/libykneomgr/"
  url "https://developers.yubico.com/libykneomgr/Releases/libykneomgr-0.1.8.tar.gz"
  sha256 "2749ef299a1772818e63c0ff5276f18f1694f9de2137176a087902403e5df889"

  bottle do
    cellar :any
    sha256 "56a5439c432c82b45b9722f22157b7194ed5604d0e67ab4189a9a07f2abf0325" => :el_capitan
    sha256 "cd80f8068e58d2c4982198eb398a85e816f772306efd7263e10a38d680c67190" => :yosemite
    sha256 "8c9a67b67b45f981fec4f6fa3a8a512e2d39055866b8c3df941fc16bcbf5c4c0" => :mavericks
  end

  head do
    url "https://github.com/Yubico/libykneomgr.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gengetopt" => :build
  end

  option :universal

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "libzip"

  def install
    ENV.universal_binary if build.universal?

    system "make", "autoreconf" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match "0.1.8", shell_output("#{bin}/ykneomgr --version")
  end
end
