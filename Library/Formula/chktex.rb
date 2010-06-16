require 'formula'

class Chktex <Formula
  url 'http://baruch.ev-en.org/proj/chktex/chktex-1.6.4.tar.gz'
  homepage 'http://baruch.ev-en.org/proj/chktex/'
  md5 'e1d1f70d37e97734a69c94682a2038a0'

  def install
    # Seriously, don't pause and show ASCII art
    inreplace "configure", "sleep 1", ""
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats
    "chktex requires a version of TeX, such as TeX Live or MacTeX."
  end
end
