require 'formula'

class Libcouchbase < Formula
  homepage 'http://couchbase.com/communities/c'
  url 'http://packages.couchbase.com/clients/c/libcouchbase-2.4.1.tar.gz'
  sha1 '08de7dc4199549857abe3443f3680f203ca6e0b5'

  bottle do
    revision 1
    sha1 "51ff86c202f4f5dcc6dadc330f74f40af3ee8bdf" => :mavericks
    sha1 "101ebdfdadf8b5cdc463bbf356dae098e3f91337" => :mountain_lion
    sha1 "17ec8ed2b24c2209b394765f2d6be1e8abefbfab" => :lion
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
