require 'formula'

class T1utils < Formula
  homepage 'http://www.lcdf.org/type/'
  url 'http://www.lcdf.org/type/t1utils-1.38.tar.gz'
  sha1 'a97ba119a2e376db49d9d4911472c0033e2fece8'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/t1mac", "--version"
  end
end
