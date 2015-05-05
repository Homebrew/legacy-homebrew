class Ocrad < Formula
  homepage "https://www.gnu.org/software/ocrad/"
  url "http://ftpmirror.gnu.org/ocrad/ocrad-0.25.tar.lz"
  mirror "https://ftp.gnu.org/gnu/ocrad/ocrad-0.25.tar.lz"
  sha256 "e710be9c030fbcbce2315077326c8268feb422c0bc39fa744644cbbd1f5d4dd4"

  bottle do
    cellar :any
    sha1 "bc2fb9a7569c50213477ba10f9e40f776f87d318" => :mavericks
    sha1 "e77d6f2d4056e2c47bfef3149afeada4fb7fb047" => :mountain_lion
    sha1 "96f3a02a4eea496f7318eeb97c40a0a7f3505cc3" => :lion
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
