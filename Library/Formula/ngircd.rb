require 'formula'

class Ngircd < Formula
  homepage 'http://ngircd.barton.de'
  url 'ftp://ftp.berlios.de/pub/ngircd/ngircd-21.tar.gz'
  mirror 'http://ngircd.barton.de/pub/ngircd/ngircd-21.tar.gz'
  sha256 '0edbd41304186e43f9d907a7017b40520cc90c2ce29b1339bdcd7622fffe19a0'

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
