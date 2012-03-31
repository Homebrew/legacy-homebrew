require 'formula'

class Svrcore < Formula
  url 'http://ftp.mozilla.org/pub/mozilla.org/directory/svrcore/releases/4.0.4/src/svrcore-4.0.4.tar.bz2'
  homepage 'https://wiki.mozilla.org/LDAP_C_SDK'
  md5 '46bcdc82624d11c1bb168cf9f15e066c'

  depends_on 'nss'

  def install
    ENV.deparallelize

    args = []
    args << 'USE_64=1' if MacOS.prefer_64_bit?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-nspr-inc=#{HOMEBREW_PREFIX}/include/nspr",
                          "--with-nss-inc=#{HOMEBREW_PREFIX}/include/nss"
    system "make #{args.join(' ')} install"
  end
end
