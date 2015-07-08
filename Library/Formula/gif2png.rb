class Gif2png < Formula
  desc "Convert GIFs to PNGs."
  homepage "http://www.catb.org/~esr/gif2png/"
  url "http://www.catb.org/~esr/gif2png/gif2png-2.5.10.tar.gz"
  sha256 "3a593156f335c4ea6be68e37e09994461193f31872362de4b27ef6301492d5fd"

  depends_on "libpng"

  def install
    ENV.deparallelize # parallel install fails

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    require "base64"
    (testpath/"test.gif").write(::Base64.decode64("R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs="))
    system "#{bin}/gif2png", "test.gif"
  end
end
