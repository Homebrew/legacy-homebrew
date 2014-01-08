require 'formula'

class Klavaro < Formula
  homepage 'http://klavaro.sourceforge.net/'
  url 'http://sourceforge.net/projects/klavaro/files/klavaro-2.00.tar.bz2'
  sha1 'c24443826496005f747b72c257202bba6bb4d462'

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
end
