require 'formula'

class Xmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/xmp/xmp/4.0.6/xmp-4.0.6.tar.gz'
  sha1 '61a7d68e4c37e7407bd35c783821bfbc2b639c87'
  head 'git://git.code.sf.net/p/xmp/xmp-cli'

  depends_on 'autoconf' if build.head?
  depends_on 'automake' if build.head?
  depends_on 'libtool'  if build.head?
  depends_on 'pkg-config' => :build
  depends_on 'libxmp'

  def install
    if build.head?
      system "glibtoolize"
      system "aclocal"
      system "autoconf"
      system "automake", "--add-missing"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make install"

    # install the included demo song
    share.install "ub-name.it" unless build.head?
  end

  def test
    system "#{bin}/xmp", "--load-only", share/"ub-name.it"
  end
end
