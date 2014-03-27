require 'formula'

class Ginac < Formula
  homepage 'http://www.ginac.de/'
  url 'http://www.ginac.de/ginac-1.6.2.tar.bz2'
  sha1 'c93913c4c543874b2ade4f0390030641be7e0c41'

  depends_on 'pkg-config' => :build
  depends_on 'cln'
  depends_on 'readline'

  # Fixes compilation with libc++; already applied upstream
  patch do
    url "http://www.ginac.de/ginac.git?p=ginac.git;a=commitdiff_plain;h=5bf87cea66bb2071222c2910ed68c2649a98906c"
    sha1 "415dad5f0f233268ad743e5beacf99c03bb339ae"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
