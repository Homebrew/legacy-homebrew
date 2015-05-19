class Yaf < Formula
  desc "Yet another flowmeter: processes packet data from pcap(3)"
  homepage "https://tools.netsa.cert.org/yaf/"
  url "https://tools.netsa.cert.org/releases/yaf-2.6.0.tar.gz"
  sha1 "ac1ac70a8d1ed8b8dbbfd5ec803880a74fa2894b"

  bottle do
    sha1 "08cbd663f3673eef87f3c086ad149a289c24959b" => :yosemite
    sha1 "3f44f3792eb169334cbc8bfacabf6883fdc79b83" => :mavericks
    sha1 "75c573eef68f5e27bffcf04919974759ba73a471" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libfixbuf"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    input = test_fixtures("test.pcap")
    output = `#{bin}/yaf --in #{input} | #{bin}/yafscii`
    expected = "2014-10-02 10:29:06.168 - 10:29:06.169 (0.001 sec) tcp 192.168.1.115:51613 => 192.168.1.118:80 71487608:98fc8ced S/APF:AS/APF (7/453 <-> 5/578) rtt 0 ms"
    assert_equal expected, output.strip
  end
end
