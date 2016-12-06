require 'formula'

class Genet < Formula
  homepage 'http://www.lsi.upc.edu/~jcarmona/genet.html'
  head 'http://svn.gna.org/svn/service-tech/trunk/genet'
  url 'http://download.gna.org/service-tech/genet/genet-1.2.tar.gz'
  sha1 '3daa288ee932c502b79bbe44d0ce55f12994b099'

  depends_on 'autoconf' if build.head?
  depends_on 'automake'if build.head?
  depends_on 'libtool'if build.head?
  depends_on 'gengetopt'if build.head?
  depends_on 'help2man'if build.head?

  def install
    system "autoreconf -i" if build.head?
    system "./configure", "--disable-assert",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
