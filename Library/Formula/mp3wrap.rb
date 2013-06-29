require 'formula'

class Mp3wrap < Formula
  homepage 'http://mp3wrap.sourceforge.net/'
  url 'http://superb-sea2.dl.sourceforge.net/project/mp3wrap/mp3wrap/mp3wrap%200.5/mp3wrap-0.5-src.tar.gz'
  sha1 '458b7e9dce5d7a867b1be73554dd14043a4cd421'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
