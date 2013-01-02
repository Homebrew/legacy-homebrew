require 'formula'

class Quilt < Formula
  homepage 'http://savannah.nongnu.org/projects/quilt'
  url 'http://download.savannah.gnu.org/releases/quilt/quilt-0.60.tar.gz'
  sha1 'c93c79598c55ba288f60babcc74a9fc9b04404b6'

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
