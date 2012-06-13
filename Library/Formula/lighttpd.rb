require 'formula'

class Lighttpd < Formula
  homepage 'http://www.lighttpd.net/'
  url 'http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.30.tar.bz2'
  sha256 '0d795597e4666dbf6ffe44b4a42f388ddb44736ddfab0b1ac091e5bb35212c2d'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'
  depends_on 'lua' if ARGV.include? '--with-lua'

  def options
    [['--with-lua', 'Include Lua scripting support for mod_magnet']]
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-openssl
      --with-ldap
    ]
    args << "--with-lua" if ARGV.include? '--with-lua'
    system "./configure", *args
    system "make install"
  end
end
