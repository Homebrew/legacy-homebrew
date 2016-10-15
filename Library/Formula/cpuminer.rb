require 'formula'

class Cpuminer < Formula
  homepage 'https://github.com/pooler/cpuminer'
  url 'http://downloads.sourceforge.net/project/cpuminer/pooler-cpuminer-2.2.3.tar.gz'
  sha1 '985ad94db5bd6579dff42933f7fe99f1ba45b364'
  head 'https://github.com/pooler/cpuminer.git'

  depends_on 'pkg-config' => :build
  depends_on 'autoconf' => :build if build.head?
  depends_on 'automake' => :build if build.head?
  depends_on 'curl'
  depends_on 'jansson'

  def install
    system "./autogen.sh" if build.head?
    system "./nomacro.pl"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
