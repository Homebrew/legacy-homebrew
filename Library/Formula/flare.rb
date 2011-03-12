require 'formula'

class Flare <Formula
  url 'http://labs.gree.jp/data/source/flare-1.0.11.tgz'
  head 'git://github.com/fujimoto/flare.git'
  homepage 'http://labs.gree.jp/Top/OpenSource/Flare-en.html'
  md5 '8be9ac019c8e114bdff246daa82033a6'

  depends_on 'tokyo-cabinet'
  depends_on 'boost'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
