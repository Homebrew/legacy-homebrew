require 'formula'

class Klavaro < Formula
  homepage 'http://klavaro.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/klavaro/klavaro-1.9.5.tar.bz2'
  sha1 'd9d0bf226ee6f622f674fcc8a526528a31385bf6'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'intltool'
  depends_on 'gtkdatabox'
  depends_on :x11

  def install
    ENV.append 'LDFLAGS', '-lgmodule-2.0'
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/klavaro"
  end
end
