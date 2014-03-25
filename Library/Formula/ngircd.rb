require 'formula'

class Ngircd < Formula
  homepage 'http://ngircd.barton.de'
  url 'http://ngircd.barton.de/pub/ngircd/ngircd-21.1.tar.gz'
  mirror 'http://ngircd.mirror.3rz.org/pub/ngircd/ngircd-21.1.tar.gz'
  sha256 '96083ae7dbc5df852efc904fff4800959f103554de2c6d096deaa5408135f59e'

  option 'with-iconv', 'Enable character conversion using libiconv.'
  option 'with-pam', 'Enable user authentication using PAM.'

  # Older Formula used the next option by default, so keep it unless
  # deactivated by the user:
  option 'without-ident', 'Disable "IDENT" ("AUTH") protocol support.'

  depends_on 'libident' if build.with? 'ident'

  def install
    args =%W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
      --with-openssl
    ]

    args << "--with-iconv" if build.with? "iconv"
    args << "--with-ident" if build.with? "ident"
    args << "--with-pam" if build.with? "pam"

    system "./configure", *args
    system "make install"
  end
end
