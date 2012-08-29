require 'formula'

class Remctl < Formula
  homepage 'http://www.eyrie.org/~eagle/software/remctl/'
  url 'http://archives.eyrie.org/software/kerberos/remctl-3.2.tar.gz'
  sha1 'f49c287c29b6b289995b8907edc6ecba4c298c99'

  depends_on 'pcre'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre=#{HOMEBREW_PREFIX}"
    system "make install"
  end

  def test
    system "#{bin}/remctl", "-v"
  end
end
