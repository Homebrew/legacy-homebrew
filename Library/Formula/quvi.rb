require 'formula'

class Quvi < Formula
  homepage 'http://quvi.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/quvi/0.9/quvi/quvi-0.9.5.tar.xz'
  sha1 '8040b8fef103350c462ba51fa614cb35a2bc1873'

  depends_on 'pkg-config' => :build
  depends_on 'libquvi'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/quvi", "--version"
  end
end
