class Miniupnpc < Formula
  desc "UpnP IGD client library and daemon"
  homepage "http://miniupnp.tuxfamily.org"
  url "http://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-1.9.20150609.tar.gz"
  sha256 "86e6ccec5b660ba6889893d1f3fca21db087c6466b1a90f495a1f87ab1cd1c36"

  bottle do
    cellar :any
    sha256 "b31e62a6331c82219bdf674c9d5b366f1288f203b947f446bbade154ab54025d" => :yosemite
    sha256 "ffc0d9665983408ee86c4e5aae53c66abb22f56d700c8ceea6bd01f2a3875c75" => :mavericks
    sha256 "ba1333c0e47f68fb0b11e945ada0aff81b69517aea4356f936fed0eaf357475e" => :mountain_lion
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end
end
