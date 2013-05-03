require 'formula'

class Gocr < Formula
  homepage 'http://jocr.sourceforge.net/'
  url 'http://www-e.uni-magdeburg.de/jschulen/ocr/gocr-0.49.tar.gz'
  sha1 '3db05b8970f5fabd0024fa0a0c877349b7e88cb4'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # --mandir doesn't work correctly; fix broken Makefile
    inreplace "man/Makefile" do |s|
      s.change_make_var! 'mandir', '/share/man'
    end

    system "make install"
  end
end
