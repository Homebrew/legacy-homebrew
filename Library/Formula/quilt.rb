require 'formula'

class Quilt < Formula
  homepage 'http://savannah.nongnu.org/projects/quilt'
  url 'http://download.savannah.gnu.org/releases/quilt/quilt-0.63.tar.gz'
  sha1 '19f2ba0384521eb3d8269b8a1097b16b07339be5'

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
