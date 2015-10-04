class Ocrad < Formula
  desc "Optical character recognition (OCR) program"
  homepage "https://www.gnu.org/software/ocrad/"
  url "http://ftpmirror.gnu.org/ocrad/ocrad-0.25.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ocrad/ocrad-0.25.tar.lz"
  sha256 "e710be9c030fbcbce2315077326c8268feb422c0bc39fa744644cbbd1f5d4dd4"

  bottle do
    cellar :any
    sha256 "99dba4fcc35dcea80dcf70e783832a57578f36406aa9a465398cf511ff2bae6e" => :yosemite
    sha256 "ee28a84a3c13a281f601f92920201a00af54509201f62ffb9d84d0e554001c7d" => :mavericks
    sha256 "2e338636210625c15a91389b2d53b7464c05c38017d0fba37076e100794668e1" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CXXFLAGS=#{ENV.cxxflags}"
  end

  test do
    (testpath/"test.pbm").write <<-EOS.undent
      P1
      # This is an example bitmap of the letter "J"
      6 10
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      1 0 0 0 1 0
      0 1 1 1 0 0
      0 0 0 0 0 0
      0 0 0 0 0 0
    EOS
    assert_equal "J", `#{bin}/ocrad #{testpath}/test.pbm`.strip
  end
end
