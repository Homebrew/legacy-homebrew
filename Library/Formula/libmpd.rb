require 'formula'

class Libmpd < Formula
  url 'http://launchpad.net/gmpc/trunk/0.19.0/+download/libmpd-0.19.0.tar.gz'
  homepage 'http://gmpc.wikia.com/wiki/Libmpd'
  md5 'a994f5f25a22c778926a3684c3e3050d'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
