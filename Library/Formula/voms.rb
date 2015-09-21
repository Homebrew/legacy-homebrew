class Voms < Formula
  desc "Virtual organization membership service"
  homepage "https://github.com/italiangrid/voms"
  url "https://github.com/italiangrid/voms/archive/2_0_11.tar.gz"
  sha256 "f665712f68fee445bb3247c214a64ecf00a9f858dadd585d26ff076d29e870e0"
  revision 1

  bottle do
    cellar :any
    sha256 "1324515f992f331be76152f62d01ef9364f0654c82c0995fc8622748e7c7cdd6" => :el_capitan
    sha256 "eaa56dee0ee58a47babfdf49307d79fddd30d1273512f73021888f24f1d8ee08" => :yosemite
    sha256 "01ed7c6185bbd2609e958065c1d58bdd8617abccdcfd3d8875faae532d327dea" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
  end
end
