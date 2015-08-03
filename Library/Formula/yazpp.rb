class Yazpp < Formula
  desc "C++ API for the Yaz toolkit"
  homepage "http://www.indexdata.com/yazpp"
  url "http://ftp.indexdata.dk/pub/yazpp/yazpp-1.6.2.tar.gz"
  sha256 "66943e4260664f9832ac654288459d447d241f1c26cab24902944e8b15c49878"

  bottle do
    cellar :any
    sha1 "899b5247fed7393c22faca121a2a8a96d66e3c64" => :yosemite
    sha1 "4c193c80fbd6339ebd287678c08165f2f61d31c8" => :mavericks
    sha1 "d8455aa52a5596c60ef08fe82551534eb1be81dc" => :mountain_lion
  end

  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
