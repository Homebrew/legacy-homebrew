require 'formula'

class Xmp < Formula
  homepage 'http://xmp.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/xmp/xmp/4.0.7/xmp-4.0.7.tar.gz'
  sha1 '0817146ff66ba3557963b8857aa80b4f63a56fc8'

  head do
    url 'git://git.code.sf.net/p/xmp/xmp-cli'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'libtool'  => :build
  end

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
  end
end
