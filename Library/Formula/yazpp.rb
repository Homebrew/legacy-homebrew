class Yazpp < Formula
  homepage "http://www.indexdata.com/yazpp"
  url "http://ftp.indexdata.dk/pub/yazpp/yazpp-1.6.2.tar.gz"
  sha1 "faafbc5f1f78c6951533188eb400a7d56c2e6cf1"

  bottle do
    cellar :any
    sha1 "adf04e898874c08f22d060945c560407755cae5f" => :yosemite
    sha1 "4717d26eb8d06bcdd65d5094f8d34c6c2f0a050b" => :mavericks
    sha1 "b6742549de29b1f5d6e59d9468ead973c791f668" => :mountain_lion
  end

  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
