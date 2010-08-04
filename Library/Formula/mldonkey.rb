require 'formula'

class Mldonkey <Formula
  url 'http://downloads.sourceforge.net/project/mldonkey/mldonkey/3.0.3/mldonkey-3.0.3.tar.bz2'
  homepage 'http://mldonkey.sourceforge.net/Main_Page'
  md5 'b5b5252fe60b5ec52396c9f58b7cb577'

  depends_on 'objective-caml'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
