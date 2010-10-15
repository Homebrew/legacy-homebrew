require 'formula'

class Libqrencode <Formula
  url 'http://megaui.net/fukuchi/works/qrencode/qrencode-3.1.0.tar.gz'
  homepage 'http://megaui.net/fukuchi/works/qrencode/index.en.html'
  md5 'fc300af948b36b2197ede0d131c12e21'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
