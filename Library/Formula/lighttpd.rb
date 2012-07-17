require 'formula'

class Lighttpd < Formula
  homepage 'http://www.lighttpd.net/'
  url 'http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.31.tar.bz2'
  sha256 '5209e7a25d3044cb21b34d6a2bb3a6f6c216ba903ea486a803d070582e5e26ac'

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
