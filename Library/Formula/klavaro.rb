require 'formula'

class Klavaro < Formula
  homepage 'http://klavaro.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/klavaro/klavaro-1.9.7.tar.bz2'
  sha1 'bc734d2e95570453f95a500689b445d077fe63b9'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gtk+'
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
