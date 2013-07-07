require 'formula'

class Quvi < Formula
  homepage 'http://quvi.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/quvi/0.4/quvi/quvi-0.4.2.tar.bz2'
  sha1 'ba67a380785212886089d75f8aa1480d6c05936e'

  depends_on 'pkg-config' => :build
  depends_on 'libquvi'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/quvi", "--version"
  end
end
