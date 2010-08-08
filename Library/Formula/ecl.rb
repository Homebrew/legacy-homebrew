require 'formula'

class Ecl <Formula
  url 'http://downloads.sourceforge.net/project/ecls/ecls/10.4/ecl-10.4.1.tar.gz'
  homepage 'http://ecls.sourceforge.net/'
  md5 'be53f5e55a3f07c7cfb5fb5cd9a2a3f0'

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--enable-unicode"
    system "make"
    system "make install"
  end
end
