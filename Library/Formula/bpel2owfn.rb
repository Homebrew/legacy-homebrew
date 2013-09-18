require 'formula'

class Bpel2owfn < Formula
  homepage 'http://www.gnu.org/software/bpel2owfn'
  head 'http://svn.gna.org/svn/service-tech/trunk/bpel2owfn'
  url 'http://download.gna.org/service-tech/bpel2owfn/bpel2owfn-2.4.tar.gz'
  sha1 '7917a990d0df53f9edd3a775063036b7a60d6e71'

  depends_on 'autoconf' if build.head?
  depends_on 'automake' if build.head?
  depends_on 'flex' if build.head?
  depends_on 'bison' if build.head?
  depends_on 'gengetopt' if build.head?
  depends_on 'help2man' if build.head?
  depends_on 'kimwitu++' if build.head?
  depends_on 'gnu-sed' if build.head?

  def install
    system "autoreconf -i" if build.head?
    system "./configure", "--disable-assert",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def test
    system "#{bin}/bpel2owfn", "--help"
  end
end
