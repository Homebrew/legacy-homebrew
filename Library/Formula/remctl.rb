require 'formula'

class Remctl < Formula
  homepage 'http://www.eyrie.org/~eagle/software/remctl/'
  url 'http://archives.eyrie.org/software/kerberos/remctl-3.8.tar.gz'
  sha1 '81d142cfeb1efa6582626e0c747139c83837b422'

  depends_on 'pcre'
  depends_on 'libevent'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre=#{HOMEBREW_PREFIX}"
    system "make install"
  end

  test do
    system "#{bin}/remctl", "-v"
  end
end
