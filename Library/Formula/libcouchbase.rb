require 'formula'

class Libcouchbase < Formula
  homepage 'http://couchbase.com/communities/c'
  url 'http://packages.couchbase.com/clients/c/libcouchbase-2.1.3.tar.gz'
  sha1 '460e6b8744b3d5634c5284ff4c690c207c61f9a6'

  option :universal
  option 'with-libev-plugin', 'Build libev IO plugin (will pull libev dependency)'
  option 'without-libevent-plugin', 'Do not build libevent plugin (will remove libevent dependency)'

  depends_on 'libev' if build.with?('libev-plugin')
  depends_on 'libevent' if build.with?('libevent-plugin')

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--disable-examples",
      "--disable-tests", # don't download google-test framework
      "--disable-couchbasemock"
    ]
    if build.universal?
      args << "--enable-fat-binary"
      ENV.universal_binary
    end
    if build.without?('libev-plugin') && build.without?("libevent-plugin")
      # do not do plugin autodiscovery
      args << "--disable-plugins"
    end
    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/cbc", "version"
  end
end
