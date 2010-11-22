require 'formula'

class Quvi <Formula
  url 'http://quvi.googlecode.com/files/quvi-0.2.2.tar.bz2'
  sha1 'cfeacf4c0a9958ba42ecab65098d71ecdcdd02f4'
  homepage 'http://code.google.com/p/quvi/'

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
