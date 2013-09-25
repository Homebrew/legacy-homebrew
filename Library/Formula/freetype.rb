require 'formula'

class Freetype < Formula
  homepage 'http://www.freetype.org'
  url 'http://downloads.sf.net/project/freetype/freetype2/2.5.0/freetype-2.5.0.1.tar.gz'
  sha1 '2d539b375688466a8e7dcc4260ab21003faab08c'

  bottle do
    # Included with X11 so no bottle needed before Mountain Lion.
    sha1 '17f543980ff81f7173f5e6b2812c0582bbaade8c' => :mountain_lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on :libpng

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/freetype-config", '--cflags', '--libs', '--ftversion',
      '--exec-prefix', '--prefix'
  end
end
