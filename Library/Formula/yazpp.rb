class Yazpp < Formula
  desc "C++ API for the Yaz toolkit"
  homepage "http://www.indexdata.com/yazpp"
  url "http://ftp.indexdata.dk/pub/yazpp/yazpp-1.6.2.tar.gz"
  sha256 "66943e4260664f9832ac654288459d447d241f1c26cab24902944e8b15c49878"

  bottle do
    cellar :any
    sha256 "624c5aabfd95a84f62bf8af42837241bcf05bebf16a086697bfb3b097463ad70" => :yosemite
    sha256 "023b4f53216ae74be67387282a813ba56caf15316cd5c9e6c40eff28e3e79a6c" => :mavericks
    sha256 "f3e546d6266e220e80031a9573b3670168098f48730e48ac190dc11700676e31" => :mountain_lion
  end

  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
