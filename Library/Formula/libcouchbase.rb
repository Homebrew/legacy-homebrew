require 'formula'

class Libcouchbase < Formula
  homepage 'http://couchbase.com/communities/c'
  url 'http://packages.couchbase.com/clients/c/libcouchbase-2.3.2.tar.gz'
  sha1 'e0c885e90aa37c2fcd3a3b188fd0bd1638b58276'

  bottle do
    sha1 "5b68f33165ee3fb89323a7f35ab32860108d8c14" => :mavericks
    sha1 "687f01a5258627f6ec9eb087f227c1a3b0a19493" => :mountain_lion
    sha1 "dd1e96f09e6bf7d81e8c08603e064bd3d3bc1d3b" => :lion
  end

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

  test do
    system "#{bin}/cbc", "version"
  end
end
