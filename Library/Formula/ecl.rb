require 'formula'

class Ecl < Formula
  homepage 'http://ecls.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ecls/ecls/13.5/ecl-13.5.1.tgz'
  sha1 'db7f732e5e12182118f00c02d8d2531f6d6aefb2'

  depends_on 'gmp'

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--enable-unicode=yes", "--enable-threads=yes", "--with-system-gmp=yes"
    system "make"
    system "make install"
  end
end
