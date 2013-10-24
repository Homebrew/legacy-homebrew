require 'formula'

class Libcouchbase < Formula
  homepage 'http://couchbase.com/develop/c/current'
  url 'http://packages.couchbase.com/clients/c/libcouchbase-2.0.7.tar.gz'
  sha1 '3901da2f75dcc49127b0c99966a064d8f737dbf9'

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
