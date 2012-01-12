require 'formula'

class Quilt < Formula
  homepage 'http://savannah.nongnu.org/projects/quilt'
  url 'http://download.savannah.gnu.org/releases/quilt/quilt-0.48.tar.gz'
  md5 'f77adda60039ffa753f3c584a286f12b'

  depends_on 'gnu-sed'
  depends_on 'coreutils'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-sed=#{HOMEBREW_PREFIX}/bin/gsed",
                          "--without-getopt"
    system "make"
    system "make install"
  end
end
