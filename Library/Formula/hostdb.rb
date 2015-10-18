class Hostdb < Formula
  desc "Generate DNS zones and DHCP configuration from hostlist.txt"
  homepage "https://code.google.com/p/hostdb/"
  url "https://hostdb.googlecode.com/files/hostdb-1.004.tgz"
  sha256 "beea7cfcdc384eb40d0bc8b3ad2eb094ee81ca75e8eef7c07ea4a47e9f0da350"

  def install
    bin.install Dir["bin/*"]
    doc.install Dir["docs/*"]
    pkgshare.install "examples"
  end

  test do
    system("#{bin}/mkzones -z #{pkgshare}/examples/example1/zoneconf.txt < #{pkgshare}/examples/example1/hostdb.txt")
    expected = /^4 \s+ IN \s+ PTR \s+ vector\.example\.com\.$/x
    assert_match(expected, (testpath/"INTERNAL.179.32.64.in-addr.arpa").read)
  end
end
