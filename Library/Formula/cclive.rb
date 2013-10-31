require 'formula'

class Cclive < Formula
  homepage 'http://cclive.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/cclive/0.7/cclive-0.7.16.tar.xz'
  sha1 '2bdee70f5e2026165ca444a306bb76fc5ede97b4'

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
