class Tmpreaper < Formula
  homepage "https://packages.debian.org/tmpreaper"
  url "https://mirrors.kernel.org/debian/pool/main/t/tmpreaper/tmpreaper_1.6.13+nmu1.tar.gz"
  mirror "http://ftp.us.debian.org/debian/pool/main/t/tmpreaper/tmpreaper_1.6.13+nmu1.tar.gz"
  sha256 "c88f05b5d995b9544edb7aaf36ac5ce55c6fac2a4c21444e5dba655ad310b738"
  version "1.6.13_nmu1"

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
