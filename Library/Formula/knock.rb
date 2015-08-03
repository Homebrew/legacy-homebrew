class Knock < Formula
  desc "Port-knock server"
  homepage "http://www.zeroflux.org/projects/knock"
  url "http://www.zeroflux.org/proj/knock/files/knock-0.7.tar.gz"
  sha256 "9938479c321066424f74c61f6bee46dfd355a828263dc89561a1ece3f56578a4"

  bottle do
    cellar :any
    sha1 "e81973835ea940928a166c0edc2c405fe8a6cac5" => :yosemite
    sha1 "df0459ca7e7f8b18cd719e333c7a016f130c2e88" => :mavericks
    sha1 "ab688df7694977ee058159505c2b3f674df31fc4" => :mountain_lion
  end

  head do
    url "https://github.com/jvinet/knock.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-fi" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/knock", "localhost", "123:tcp"
  end
end
