require 'formula'

class Qrencode < Formula
  url 'http://fukuchi.org/works/qrencode/qrencode-3.2.0.tar.gz'
  homepage 'http://fukuchi.org/works/qrencode/index.html.en'
  sha1 '1c9cf02cc8e79dddc7238cad64b0bf3c48e94210'

  depends_on 'pkg-config' => :build

  def install
    ENV.x11 # For libpng

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
