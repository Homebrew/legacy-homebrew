class Ipinfo < Formula
  desc "Tool for calculation of IP networks"
  homepage "http://kyberdigi.cz/projects/ipinfo/"
  url "http://kyberdigi.cz/projects/ipinfo/files/ipinfo-1.2.tar.gz"
  sha256 "19e6659f781a48b56062a5527ff463a29c4dcc37624fab912d1dce037b1ddf2d"

  bottle do
    cellar :any_skip_relocation
    sha256 "ecb331ae035cf5963afc8e8adf371d80f936960bf0d5ba379b18761263a1b040" => :el_capitan
    sha256 "e1ce332c726d060521e97a5402746a60778d91beaf28704d9ce5bb6e17451fb3" => :yosemite
    sha256 "686fe99fef85ecbfdcc9c922f6cda898362d70bb9f5b9b7e1aeba8e30c284196" => :mavericks
  end

  def install
    system "make", "BINDIR=#{bin}", "MANDIR=#{man1}", "install"
  end

  test do
    system bin/"ipinfo", "127.0.0.1"
  end
end
