require 'formula'

class Libcouchbase < Formula
  homepage 'http://couchbase.com/communities/c'
  url 'http://packages.couchbase.com/clients/c/libcouchbase-2.4.2.tar.gz'
  sha1 '671ec846d69cb1c703c20c055c4f2daa91ae6a2e'

  bottle do
    sha1 "7378d93afb9c869cb575a3c3433b02d9b2d1ae8d" => :mavericks
    sha1 "313ed9ee0ca559e6b22267a8c6477068bcba0d70" => :mountain_lion
    sha1 "066e5c6c5f42d03a40a7ffc571e8a4373f436104" => :lion
  end

  option :universal
  option 'with-libev-plugin', 'Build libev IO plugin (will pull libev dependency)'
  option 'without-libevent-plugin', 'Do not build libevent plugin (will remove libevent dependency)'

  depends_on 'libev' if build.with?('libev-plugin')
  depends_on 'libevent' if build.with?('libevent-plugin')
  depends_on 'openssl'

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

  test do
    system "#{bin}/cbc", "version"
  end
end
