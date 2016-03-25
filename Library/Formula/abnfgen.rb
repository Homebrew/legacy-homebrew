class Abnfgen < Formula
  desc "Quickly generate random documents that match an ABFN grammar"
  homepage "http://www.quut.com/abnfgen/"
  url "http://www.quut.com/abnfgen/abnfgen-0.17.tar.gz"
  sha256 "777a264d91a93bc9cf008d7520abb0470d7280fb38008c5f185cbf2d29640083"

  bottle do
    cellar :any_skip_relocation
    sha256 "25aa694b994374b0194f65a01afdf1911ddd366d3195a6ac6451e81f87234768" => :el_capitan
    sha256 "6020fe82950619f9ddf60265c80c2e8f2f68808618e87150d1634f5ec2c0eff8" => :yosemite
    sha256 "004aa4f75ee0e51327a69a558cb3920b6859303b1d032e32e3caabe623dc35d4" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"grammar").write %(ring = 1*12("ding" SP) "dong" CRLF)
    system "#{bin}/abnfgen", (testpath/"grammar")
  end
end
