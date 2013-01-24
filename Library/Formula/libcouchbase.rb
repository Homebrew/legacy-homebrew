require 'formula'

class Libcouchbase < Formula
  homepage 'http://couchbase.com/develop/c/current'
  url 'http://packages.couchbase.com/clients/c/libcouchbase-2.0.2.tar.gz'
  sha1 'e1f6149d2fc05e3e8be568469baed5c7234c48f3'

  option 'with-libev-plugin', 'Build libev IO plugin (will pull libev dependency)'
  option 'without-libevent-plugin', 'Do not build libevent plugin (will remove libevent dependency)'

  depends_on 'libev' if build.include?('with-libev-plugin')
  depends_on 'libevent' unless build.include?('without-libevent-plugin')

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-examples",
                          "--disable-couchbasemock"
    system "make install"
  end

  def test
    system "#{bin}/cbc-version"
  end
end
