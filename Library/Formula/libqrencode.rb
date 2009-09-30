require 'brewkit'

class Libqrencode <Formula
  url 'http://megaui.net/fukuchi/works/qrencode/qrencode-3.1.0.tar.gz'
  homepage 'http://megaui.net/fukuchi/works/qrencode/index.en.html'
  md5 'fc300af948b36b2197ede0d131c12e21'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
