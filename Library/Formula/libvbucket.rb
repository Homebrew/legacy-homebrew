require 'formula'

class Libvbucket < Formula
  homepage 'http://couchbase.com/develop/c/current'
  url 'http://packages.couchbase.com/clients/c/libvbucket-1.8.0.4.tar.gz'
  sha1 '4f24a85d251c0fca69e7705681a2170dd794492a'

  bottle do
    cellar :any
    sha1 "b11b9b98c5ba3399ad4650e165f52f28447944c9" => :mavericks
    sha1 "5c0987cd64e45d2b4fd95d833a6344d98130df76" => :mountain_lion
    sha1 "71399bbf3403fc8cddf3a1f379ad234efee34a61" => :lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-docs"
    system "make install"
  end

  test do
    require 'utils/json'
    json = Utils::JSON.dump(
      {
        "hashAlgorithm" => "CRC",
        "numReplicas" => 2,
        "serverList" => ["server1:11211","server2:11210","server3:11211"],
        "vBucketMap" => [[0,1,2],[1,2,0],[2,1,-1],[1,2,0]],
      }
    )

    expected = <<-EOS.undent
      key: hello master: server1:11211 vBucketId: 0 couchApiBase: (null) replicas: server2:11210 server3:11211
      key: world master: server2:11210 vBucketId: 3 couchApiBase: (null) replicas: server3:11211 server1:11211
      EOS

    output = pipe_output("#{bin}/vbuckettool - hello world", json)
    assert_equal expected, output
  end
end
