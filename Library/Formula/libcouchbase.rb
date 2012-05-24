require 'formula'

class Libcouchbase < Formula
  homepage 'http://couchbase.com/develop/c/current'
  url 'http://packages.couchbase.com/clients/c/libcouchbase-1.0.3.tar.gz'
  md5 '1063f659a50a036e0fb435bbde76da90'

  depends_on 'libevent'
  depends_on 'libvbucket'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-couchbasemock"
    system "make install"
  end

  def test
    system "#{bin}/cbc-version"
  end
end
