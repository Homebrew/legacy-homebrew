require 'formula'

class Xmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmp/xmp/4.0.3/xmp-4.0.3.tar.gz'
  sha1 '1d33cedfc2f56c6c7dc1688a2d226083bc523e2e'
  head 'git://git.code.sf.net/p/xmp/xmp-cli'

  depends_on :autoconf if build.head?
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
