class Shorten < Formula
  desc "Waveform compression"
  homepage "http://www.etree.org/shnutils/shorten/"
  url "http://www.etree.org/shnutils/shorten/dist/src/shorten-3.6.1.tar.gz"
  sha256 "ce22e0676c93494ee7d094aed9b27ad018eae5f2478e8862ae1e962346405b66"

  bottle do
    cellar :any
    sha256 "5f48b61ce709915830f433dd381fe531c1354b56619bbdb441dc19f985df7467" => :yosemite
    sha256 "a802da618fffa3eb292705140c882fcedbffae09017f0efdf69085004952a148" => :mavericks
    sha256 "ca55e37b24202c500a03dfe36a41dd06ebaa02b19ddf65c26cc440376149c5da" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/shorten", test_fixtures("test.wav"), "test"
    assert File.exist? "test"
  end
end
