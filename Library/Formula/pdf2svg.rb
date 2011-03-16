require 'formula'

class Pdf2svg < Formula
  url 'http://www.cityinthesky.co.uk/files/pdf2svg-0.2.1.tar.gz'
  homepage 'http://www.cityinthesky.co.uk/pdf2svg.html'
  md5 '59b3b9768166f73b77215e95d91f0a9d'

  depends_on "poppler"
  depends_on "gtk+" # Includes atk and cairo, through pango, if needed

  def install
    ENV.x11
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
