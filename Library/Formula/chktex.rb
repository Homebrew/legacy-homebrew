require 'formula'

class Chktex < Formula
  url 'http://baruch.ev-en.org/proj/chktex/chktex-1.6.4.tar.gz'
  homepage 'http://baruch.ev-en.org/proj/chktex/'
  sha1 'b42b6a69e17373760c9653cce0add6ffc741312b'

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
