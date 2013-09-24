require 'formula'
class Maxima < Formula
  homepage 'http://maxima.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/maxima/Maxima-source/5.31.1-source/maxima-5.31.1.tar.gz'
  sha1 '10f5e91ee362b4c14ccd5a00d19e995df5610434'

   depends_on 'clisp'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
