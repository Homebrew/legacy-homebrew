class Tmpreaper < Formula
  desc "Clean up files in directories based on their age"
  homepage "https://packages.debian.org/tmpreaper"
  url "https://mirrors.kernel.org/debian/pool/main/t/tmpreaper/tmpreaper_1.6.13+nmu1.tar.gz"
  mirror "http://ftp.us.debian.org/debian/pool/main/t/tmpreaper/tmpreaper_1.6.13+nmu1.tar.gz"
  sha256 "c88f05b5d995b9544edb7aaf36ac5ce55c6fac2a4c21444e5dba655ad310b738"
  version "1.6.13_nmu1"

  bottle do
    cellar :any
    sha256 "7e634ee1b709b8751a52e31c02432481267e58bc6f584dc7ac23c08e330cc169" => :yosemite
    sha256 "d14aabae2826469b0c878dd517c2017d952773d406fa4f71af4e2951de602198" => :mavericks
    sha256 "6c75ed498baad36cda1386e90b5be53c3898469e0a9ac7847ba854a4e912069c" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
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
