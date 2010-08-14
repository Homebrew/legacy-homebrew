require 'formula'

class Gocr <Formula
  url 'http://www-e.uni-magdeburg.de/jschulen/ocr/gocr-0.48.tar.gz'
  homepage 'http://jocr.sourceforge.net/'
  md5 '9882ba9a93fcb18ab704a10da80c228c'

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
