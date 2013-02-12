require 'formula'

class Lighttpd < Formula
  homepage 'http://www.lighttpd.net/'
  url 'http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.32.tar.bz2'
  sha256 '60691b2dcf3ad2472c06b23d75eb0c164bf48a08a630ed3f308f61319104701f'

  option 'with-lua', 'Include Lua scripting support for mod_magnet'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'lua' => :optional
  depends_on 'libev' => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-openssl
      --with-ldap
      --with-zlib
      --with-bzip2
      --with-attr
    ]

    args << "--with-lua" if build.with? 'lua'
    args << "--with-libev" if build.with? 'libev'

    system "./configure", *args
    system "make install"
  end
end
