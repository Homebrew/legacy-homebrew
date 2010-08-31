require 'formula'

class GnuBarcode <Formula
  url 'ftp://ftp.gnu.org/gnu/barcode/barcode-0.98.tar.gz'
  homepage 'http://www.gnu.org/software/barcode/barcode.html'
  md5 '7f10c3307b84a19a4ab2fa4b3f2974da'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    inreplace "Makefile" do |s|
      s.change_make_var! "MAN1DIR", man1
      s.change_make_var! "MAN3DIR", man3
    end

    system "make"
    system "make install"
  end
end
