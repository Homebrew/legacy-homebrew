class Wyrd < Formula
  desc "Ncurses-based front-end for remind"
  homepage "http://pessimization.com/software/wyrd/"
  url "http://pessimization.com/software/wyrd/wyrd-1.4.6.tar.gz"
  sha256 "b2b51d6fb38f8b8b3ec30ee72093f791ba9b6fe35418191bc2011d2c8079997e"

  bottle do
    sha256 "1581d07d741f4b545cfc2d7fb9da05c5312cbff455b7b67c74d4504f31bc7aa9" => :yosemite
    sha256 "6515d84612a9e38c506664a8ff65dfc9b99f4865aebe3ee77715aa6c6dcc157c" => :mavericks
    sha256 "494baad62a7f6743d1a684e2c320a9ceda829f8f234b55894a36ad677f28582f" => :mountain_lion
  end

  depends_on "remind"
  depends_on "ocaml" => :build
  depends_on "camlp4" => :build

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-utf8"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "REM Jan 1 2015 AT 00:01 MSG Happy New Year!\n", shell_output("#{bin}/wyrd --add 'Happy New Year! on 2015-01-1 at 00:01' /dev/stdout")
  end
end
