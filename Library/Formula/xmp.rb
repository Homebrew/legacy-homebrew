require 'formula'

class Xmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmp/xmp/4.0.4/xmp-4.0.4.tar.gz'
  sha1 '2eb9750790d660b014fad75d5331b4d05553302b'
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
