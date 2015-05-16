class Yazpp < Formula
  homepage "http://www.indexdata.com/yazpp"
  url "http://ftp.indexdata.dk/pub/yazpp/yazpp-1.6.2.tar.gz"
  sha1 "faafbc5f1f78c6951533188eb400a7d56c2e6cf1"

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
