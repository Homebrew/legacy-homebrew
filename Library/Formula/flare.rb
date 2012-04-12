require 'formula'

class Flare < Formula
  url 'http://labs.gree.jp/data/source/flare-1.0.12.tgz'
  head 'https://github.com/fujimoto/flare.git'
  homepage 'http://labs.gree.jp/Top/OpenSource/Flare-en.html'
  sha1 'c27c5c320f1128a318bba0b459f9c855dff80d89'

  depends_on 'tokyo-cabinet'
  depends_on 'boost'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
