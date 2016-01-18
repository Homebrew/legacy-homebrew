class Tmpreaper < Formula
  desc "Clean up files in directories based on their age"
  homepage "https://packages.debian.org/sid/tmpreaper"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tmpreaper/tmpreaper_1.6.13+nmu1.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/tmpreaper/tmpreaper_1.6.13+nmu1.tar.gz"
  version "1.6.13_nmu1"
  sha256 "c88f05b5d995b9544edb7aaf36ac5ce55c6fac2a4c21444e5dba655ad310b738"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "e9992640d7c0e139caef8ccb130af90548f6435b3789b61c8c873f619e55ade9" => :el_capitan
    sha256 "a027f222a96bde98ae5f3e271d990871884a89fab8578066cc6b1cdb3a01aa2c" => :yosemite
    sha256 "31519a6cd52a36c1eb9f5a65b67b6f893d3a9f3c9d4601051cc6f33061bc8bf5" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    touch "removed"
    sleep 3
    touch "not-removed"
    system "#{sbin}/tmpreaper", "2s", "."
    assert !File.exist?("removed")
    assert File.exist?("not-removed")
  end
end
