class Gif2png < Formula
  desc "Convert GIFs to PNGs."
  homepage "http://www.catb.org/~esr/gif2png/"
  url "http://www.catb.org/~esr/gif2png/gif2png-2.5.10.tar.gz"
  sha256 "3a593156f335c4ea6be68e37e09994461193f31872362de4b27ef6301492d5fd"

  bottle do
    cellar :any
    sha256 "bef2695287ec025c045ae53ab19e7e894adb0ffd4f27e4abb0c33e85598dd6b7" => :yosemite
    sha256 "f63bffca24e8072f90b23b98a701bcedd0007ac0039e883e38376819044cfd00" => :mavericks
    sha256 "367e2fb907fe415729e147c6bdd25636fad449e30e1d52d3fc8f52d168353fba" => :mountain_lion
  end

  depends_on "libpng"

  def install
    # parallel install fails
    # emailed bug report to upstream author on 2015-07-08
    ENV.deparallelize

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    pipe_output "#{bin}/gif2png -O", File.read(test_fixtures("test.gif"))
  end
end
