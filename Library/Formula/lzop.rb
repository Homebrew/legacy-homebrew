require 'formula'

class Lzop <Formula
  url 'http://www.lzop.org/download/lzop-1.02rc1.tar.gz'
  homepage 'http://www.lzop.org/'
  md5 '4b999030716b1353c3dac049b269df7a'

  depends_on 'lzo'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
