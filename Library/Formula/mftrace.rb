class Mftrace < Formula
  homepage "http://lilypond.org/mftrace/"
  url "http://lilypond.org/download/sources/mftrace/mftrace-1.2.18.tar.gz"
  sha256 "0d31065f1d35919e311d9170bbfcdacc58736e3f783311411ed1277aa09d3261"

  bottle do
    cellar :any
    sha256 "652e03523670ef45d78679f0c5c14e193b5be7184f63f695aaf4390f49332c59" => :yosemite
    sha256 "25dea31412113a36ed3de9779abd1c075c98f6bd9097439f667d2ff6a47958cd" => :mavericks
    sha256 "044273758a1a679641c78f1b1616f54251d634618dd527d1b43aaed4b9cf1009" => :mountain_lion
  end

  depends_on "potrace"
  depends_on "t1utils"
  depends_on "fontforge" => [:recommended, :run]

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mftrace", "--version"
  end
end
