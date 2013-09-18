require 'formula'

class Sara < Formula
  homepage 'http://service-technology.org/sara'
  head 'http://svn.gna.org/svn/service-tech/trunk/sara'
  url 'http://download.gna.org/service-tech/sara/sara-1.10.tar.gz'
  sha1 '50516b6961c29ccd14fd75781c1e885ccc85f352'

  depends_on 'autoconf' if build.head?
  depends_on 'automake' if build.head?
  depends_on 'flex' if build.head?
  depends_on 'bison' if build.head?
  depends_on 'gengetopt' if build.head?
  depends_on 'help2man' if build.head?
  depends_on 'libtool' if build.head?

  def install
    ENV.deparallelize

    system "autoreconf -i" if build.head?
    system "./configure", "--disable-assert",
                          "--without-pnapi",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
