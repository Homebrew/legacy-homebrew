class Gif2png < Formula
  desc "Convert GIFs to PNGs."
  homepage "http://www.catb.org/~esr/gif2png/"
  url "http://www.catb.org/~esr/gif2png/gif2png-2.5.10.tar.gz"
  sha256 "3a593156f335c4ea6be68e37e09994461193f31872362de4b27ef6301492d5fd"

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
