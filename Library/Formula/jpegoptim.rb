class Jpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/RELEASE.1.4.3.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/j/jpegoptim/jpegoptim_1.4.3.orig.tar.gz"
  sha256 "f892f5917c8dd8259d319df204e4bc13806b90389041ca7a4a24d8a5c25c7013"
  head "https://github.com/tjko/jpegoptim.git"

  bottle do
    cellar :any
    revision 1
    sha256 "51375e2896eeee829b34c01860508651e6121c6266ec77d8898b08f832098f10" => :el_capitan
    sha256 "abb7ce068535b9f2b8a7c9213b785c63f9c3e80271c7efe8ea71bd7583d09c9c" => :yosemite
    sha256 "eff2aedc08673bfb2942cda88a725c839a1943a85d465e82360f59174b3bcc98" => :mavericks
    sha256 "a52cb9795ff62f76943d387572f2546b75b0f5bdd5662945b7132437f4f4b962" => :mountain_lion
  end

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1 # Install is not parallel-safe
    system "make", "install"
  end

  test do
    source = test_fixtures("test.jpg")
    assert_match(/OK/, shell_output("#{bin}/jpegoptim --noaction #{source}"))
  end
end
