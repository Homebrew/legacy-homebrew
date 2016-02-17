class Ctorrent < Formula
  desc "BitTorrent command-line client"
  homepage "http://www.rahul.net/dholmes/ctorrent/"
  url "https://downloads.sourceforge.net/project/dtorrent/dtorrent/3.3.2/ctorrent-dnh3.3.2.tar.gz"
  sha256 "c87366c91475931f75b924119580abd06a7b3cb3f00fef47346552cab1e24863"
  revision 2

  bottle do
    cellar :any
    sha256 "948dc4f46a2df2581d812bc09430c635d13c589448791bd744cadfa77c739baa" => :el_capitan
    sha256 "ee33a6af8447cbf0f71451dfad655a14a9b28f642c799ca7912eefe9e0fc2330" => :yosemite
    sha256 "8979644a0390f763c081556298ba1997f0db2ff9eada13f686d698af57777f32" => :mavericks
  end

  # This patch skips over negative integer values appearing before "info" section in torrent file
  # which makes ctorrent exit with "error, initial meta info failed" message.
  # Please see https://sourceforge.net/p/dtorrent/bugs/21/ for more details
  patch do
    url "https://raw.githubusercontent.com/achikin/ctorrent-patch/master/ctorrent-3.3.2-negative-ints.patch"
    sha256 "d24d04760a3480e921c54ea1af39e7bb094a8b774ee09bb8849f9c1f76731193"
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    agent_string = "Enhanced-CTorrent/dnh#{version}"
    test_url     = "http://example.com/test"

    # Arbitrary content
    (testpath/"test").write "Test\n"

    system "#{bin}/ctorrent", "-tpu", test_url, "-s", "test.meta", "test"
    expected = Regexp.escape(
      "d8:announce" \
      "#{test_url.length}:#{test_url}" \
      "10:created by" \
      "#{agent_string.length}:#{agent_string}" \
      "13:creation date"
    ) + "i\\d+e"
    actual = File.open(testpath/"test.meta", "rb").read
    assert_match(/^#{expected}/, actual)
  end
end
