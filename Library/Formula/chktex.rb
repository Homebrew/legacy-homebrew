require 'formula'

class Chktex < Formula
  homepage 'http://www.nongnu.org/chktex/'
  url 'http://download.savannah.gnu.org/releases/chktex/chktex-1.7.2.tar.gz'
  sha1 '85d9e9fbf3e89104966bd725f156c826d0b44dd9'

  depends_on :tex

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
