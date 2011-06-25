require 'formula'

class Quvi < Formula
  url 'http://sourceforge.net/projects/quvi/files/0.2/quvi-0.2.14.tar.bz2'
  sha1 '4d2a4e02db4bcb555ddb92de3a466ab608e971eb'
  homepage 'http://quvi.sourceforge.net/'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'lua'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-smut",
                          "--enable-broken"
    system "make install"
  end
end
