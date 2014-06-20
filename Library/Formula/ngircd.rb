require 'formula'

class Ngircd < Formula
  homepage 'http://ngircd.barton.de'
  url 'http://ngircd.barton.de/pub/ngircd/ngircd-21.1.tar.gz'
  mirror 'http://ngircd.mirror.3rz.org/pub/ngircd/ngircd-21.1.tar.gz'
  sha256 '96083ae7dbc5df852efc904fff4800959f103554de2c6d096deaa5408135f59e'

  bottle do
    revision 1
    sha1 "4b57669606f323726abf6d9697c0f96bf1eff0a0" => :mavericks
    sha1 "06252db0d529c3edcd14f054898e2b4220a56d80" => :mountain_lion
    sha1 "780f4368b6b17e0ab0989d004b252291fb2775c8" => :lion
  end

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
      --sysconfdir=#{HOMEBREW_PREFIX}/etc
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
