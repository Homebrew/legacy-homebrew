class Libvbucket < Formula
  desc "Utility library providing mapping to virtual buckets"
  homepage "https://couchbase.com/develop/c/current"
  url "https://s3.amazonaws.com/packages.couchbase.com/clients/c/libvbucket-1.8.0.4.tar.gz"
  sha256 "398ba491d434fc109fd64f38678916e1aa19c522abc8c090dbe4e74a2a2ea38d"

  bottle do
    cellar :any
    revision 1
    sha256 "dd69ae3261c461b15bd29e435ab95496441dfde4535cb7d6925527cdfa8c64dd" => :yosemite
    sha256 "920f0656e62f10e6fc6649b0edc4a6f46dc196f931b7c14833608d9e926a4d09" => :mavericks
    sha256 "e0cd80d589c2375f3b2f4d0f1f7f19b94264f93d603d9539c0da637eb473ce72" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-docs"
    system "make", "install"
  end

  test do
    require "utils/json"
    json = Utils::JSON.dump(
      "hashAlgorithm" => "CRC",
      "numReplicas" => 2,
      "serverList" => ["server1:11211", "server2:11210", "server3:11211"],
      "vBucketMap" => [[0, 1, 2], [1, 2, 0], [2, 1, -1], [1, 2, 0]]
    )

    expected = <<-EOS.undent
      key: hello master: server1:11211 vBucketId: 0 couchApiBase: (null) replicas: server2:11210 server3:11211
      key: world master: server2:11210 vBucketId: 3 couchApiBase: (null) replicas: server3:11211 server1:11211
      EOS

    output = pipe_output("#{bin}/vbuckettool - hello world", json)
    assert_equal expected, output
  end
end
