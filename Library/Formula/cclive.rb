require 'formula'

class Cclive < Formula
  homepage 'http://cclive.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/cclive/0.7/cclive-0.7.14.tar.xz'
  sha1 '2e4dafd7266095610a2154117a15682e5987ed89'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'quvi'
  depends_on 'boost'
  depends_on 'pcre'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
