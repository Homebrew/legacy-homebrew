require 'formula'

class Libzzip <Formula
  url 'http://downloads.sourceforge.net/project/zziplib/zziplib13/0.13.57/zziplib-0.13.57.tar.bz2'
  homepage 'http://sourceforge.net/projects/zziplib/'
  md5 '7ebb644bbd880b130435ce6dcbd3cdd3'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
