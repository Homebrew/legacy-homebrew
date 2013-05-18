require 'formula'

class Xmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmp/xmp/4.0.5/xmp-4.0.5.tar.gz'
  sha1 '3de0292afc8c0e28b3f2f9328b28bc19d0fda9d1'
  head 'git://git.code.sf.net/p/xmp/xmp-cli'

  depends_on :autoconf if build.head?
  depends_on 'pkg-config' => :build
  depends_on 'libxmp'

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    # install the included demo song
    share.install "ub-name.it" unless build.head?
  end

  def test
    system "#{bin}/xmp", "--load-only", share/"ub-name.it"
  end
end
