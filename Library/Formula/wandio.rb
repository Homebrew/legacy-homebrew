class Wandio < Formula
  desc "LibWandio I/O performance will be improved by doing any compression"
  homepage "http://research.wand.net.nz/software/libwandio.php"
  url "http://research.wand.net.nz/software/wandio/wandio-1.0.3.tar.gz"
  sha256 "31dcc1402ace3023020446d6c7284fd84447f9b36e570206a179895e1eaa705b"

  bottle do
    cellar :any
    sha256 "0ae81b1c0447cab3fcf1ff58f94bebde6e86bb932cc8e144bbbbcf7f7a34c385" => :el_capitan
    sha256 "2ab4106d0c8af37b95397392f329eb7b33fdf8938be4053f80fd8dac6e90a36c" => :yosemite
    sha256 "3b64647f03ddc63488ff8124d5da8cf6a201c0922230348fd06662ff7d917722" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--with-http",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/wandiocat", "-h"
  end
end
