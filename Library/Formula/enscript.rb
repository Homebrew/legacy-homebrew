require 'formula'

## @@ TODO: add paper definitions from Fink / debian enscript.cfg (?)
## (or should it automatically grab these from libpaper?)

class Enscript < Formula
  url 'http://alpha.gnu.org/gnu/enscript/enscript-1.6.5.90.tar.gz'
  homepage 'http://www.gnu.org/software/enscript/'
  md5 '774e6acd4d15ede54f0eda5babaa9b4b'

  depends_on 'gettext' => :build ## needs autopoint (according to debian)
  depends_on 'libpaper'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
