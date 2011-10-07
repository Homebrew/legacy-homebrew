require 'formula'

class Gocr < Formula
  url 'http://www-e.uni-magdeburg.de/jschulen/ocr/gocr-0.49.tar.gz'
  homepage 'http://jocr.sourceforge.net/'
  md5 '4e527bc4bdd97c2be15fdd818857507f'

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
