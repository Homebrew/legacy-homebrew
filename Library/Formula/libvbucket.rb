require 'formula'

class Libvbucket < Formula
  homepage 'http://couchbase.com/develop/c/current'
  url 'http://packages.couchbase.com/clients/c/libvbucket-1.8.0.4.tar.gz'
  md5 '7d4c45fad392ce3a9cf0f39420441e24'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-docs"
    system "make install"
  end

  def test
    test_json = '{"hashAlgorithm":"CRC","numReplicas":2,"serverList":["server1:11211","server2:11210","server3:11211"],"vBucketMap":[[0,1,2],[1,2,0],[2,1,-1],[1,2,0]]}'
    expected = <<OUT
key: hello master: server1:11211 vBucketId: 0 couchApiBase: (null) replicas: server2:11210 server3:11211
key: world master: server2:11210 vBucketId: 3 couchApiBase: (null) replicas: server3:11211 server1:11211
OUT
    `echo '#{test_json}' | #{bin}/vbuckettool - hello world` == expected
  end
end
