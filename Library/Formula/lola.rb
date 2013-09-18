require 'formula'

class Lola < Formula
  homepage 'http://www.informatik.uni-rostock.de/tpp/lola/'
  head 'http://svn.gna.org/svn/service-tech/trunk/lola'
  url 'http://download.gna.org/service-tech/lola/lola-1.17.tar.gz'
  sha1 '05e45e46f2fb2681ef369c2fd63f88115a912c55'

  depends_on 'autoconf' if build.head?
  depends_on 'automake' if build.head?
  depends_on 'flex' if build.head?
  depends_on 'bison' if build.head?
  depends_on 'gengetopt' if build.head?
  depends_on 'help2man' if build.head?

  def install
    ENV.deparallelize

    system "autoreconf -i" if build.head?
    system "./configure", "--disable-assert",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make" if build.head?
    system "make", "clean" if build.head?
    system "make", "all-configs"
    system "make", "install"
  end
end
