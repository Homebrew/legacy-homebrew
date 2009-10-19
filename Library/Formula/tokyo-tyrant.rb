require 'formula'

class TokyoTyrant <Formula
  url 'http://1978th.net/tokyotyrant/tokyotyrant-1.1.36.tar.gz'
  homepage 'http://1978th.net/tokyotyrant/'
  sha1 '116c413affdc649602439adc815c9dcb133cc502'

  depends_on 'tokyo-cabinet'
  depends_on 'lua'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-lua", "--enable-lua"
    system "make"
    system "make install"
  end
end
