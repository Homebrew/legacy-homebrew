require 'formula'

class Libcouchbase < Formula
  homepage 'http://couchbase.com/develop/c/current'
  url 'http://packages.couchbase.com/clients/c/libcouchbase-2.0.6.tar.gz'
  sha1 'ff9f36b07d2d9acd253aed86583461b5ecc69ad4'

  option 'with-libev-plugin', 'Build libev IO plugin (will pull libev dependency)'
  option 'without-libevent-plugin', 'Do not build libevent plugin (will remove libevent dependency)'

  depends_on 'libev' if build.include?('with-libev-plugin')
  depends_on 'libevent' unless build.include?('without-libevent-plugin')

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-examples",
                          "--disable-tests", # don't download google-test framework
                          "--disable-couchbasemock"
    system "make install"
  end

  def test
    system "#{bin}/cbc", "version"
  end
end
