require 'formula'

class TokyoTyrant <Formula
  # For some reason TT-1.1.36 wouldn't compile against TC-1.4.33
  # Also it appears the Ruby (Rufus) bindings will only work with up to 1.1.33
  url 'http://1978th.net/tokyotyrant/tokyotyrant-1.1.33.tar.gz'
  homepage 'http://1978th.net/tokyotyrant/'
  md5 '880d6af48458bc04b993bdae6ecc543d'

  depends_on 'tokyo-cabinet'
  depends_on 'lua'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-lua", "--enable-lua"
    system "make"
    system "make install"
  end
end
