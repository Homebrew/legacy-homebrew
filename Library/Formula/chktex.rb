require 'formula'

class Chktex < Formula
  url 'http://download.savannah.gnu.org/releases/chktex/chktex-1.7.1.tar.gz'
  homepage 'http://www.nongnu.org/chktex/'
  sha1 'ed94b96ed8ce65fb1cef1b5fc019045c5b2dd8a8'

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
