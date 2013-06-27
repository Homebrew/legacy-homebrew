require 'formula'

class Cclive < Formula
  homepage 'http://cclive.sourceforge.net/'
  url 'http://sourceforge.net/projects/cclive/files/0.7/cclive-0.7.13.tar.xz'
  sha1 '008ebd2e8a92e1ba07f11e7467dac48fe4acc0d4'

  depends_on 'pkg-config' => :build
  depends_on 'boost'
  depends_on 'pcre'
  depends_on 'quvi'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
