require 'formula'

class Quilt <Formula
  homepage 'http://savannah.nongnu.org/projects/quilt'
  url 'http://download.savannah.gnu.org/releases/quilt/quilt-0.48.tar.gz'
  md5 'f77adda60039ffa753f3c584a286f12b'

  depends_on 'gnu-sed'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-sed=gsed",
                          "--without-getopt"
    system "make && make install"
  end
end
