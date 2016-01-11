class Shntool < Formula
  desc "Multi-purpose tool for manipulating and analyzing WAV files"
  homepage "http://etree.org/shnutils/shntool/"
  url "http://etree.org/shnutils/shntool/dist/src/shntool-3.0.10.tar.gz"
  sha256 "74302eac477ca08fb2b42b9f154cc870593aec8beab308676e4373a5e4ca2102"

  bottle do
    cellar :any
    sha256 "46d99776bb02d9721f30a6cb9b2c44293d3fbc6b4e3f522df869a7106b09a448" => :yosemite
    sha256 "fa745e31b3c2aadb20d5c87f7175f00b3c5a39b6664ea0a9aa9d88d5767781c5" => :mavericks
    sha256 "10fb74d16244a21c15676ec9fce007167ef7784b83a0d10afb3d0f87b86ab292" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/shninfo", test_fixtures("test.wav")
  end
end
