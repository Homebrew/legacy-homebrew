require 'formula'

class TexInstalled < Requirement
  def message; <<-EOS.undent
    A TeX/LaTeX installation is required to install.
    You can obtain the TeX distribution for Mac OS X from:
        http://www.tug.org/mactex/
    EOS
  end
  def satisfied?
    which 'latex'
  end
  def fatal?
    true
  end
end

class Chktex < Formula
  homepage 'http://www.nongnu.org/chktex/'
  url 'http://download.savannah.gnu.org/releases/chktex/chktex-1.7.1.tar.gz'
  sha1 'ed94b96ed8ce65fb1cef1b5fc019045c5b2dd8a8'

  depends_on TexInstalled.new
  env :userpaths # To find TeX

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
