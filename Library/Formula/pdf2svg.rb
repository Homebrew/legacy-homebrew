require 'formula'

class Pdf2svg < Formula
  homepage 'http://www.cityinthesky.co.uk/opensource/pdf2svg'
  url 'http://www.cityinthesky.co.uk/wp-content/uploads/2013/10/pdf2svg-0.2.2.tar.gz'
  sha1 'e8d3332565f40705fbad5bd4eda9a001e563da1b'

  depends_on "pkg-config" => :build

  depends_on :x11
  depends_on "cairo"
  depends_on "poppler"
  depends_on "gtk+"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
