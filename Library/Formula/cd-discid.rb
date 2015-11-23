class CdDiscid < Formula
  desc "Read CD and get CDDB discid information"
  homepage "http://linukz.org/cd-discid.shtml"
  url "http://linukz.org/download/cd-discid-1.4.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/cd-discid/cd-discid_1.4.orig.tar.gz"
  sha256 "ffd68cd406309e764be6af4d5cbcc309e132c13f3597c6a4570a1f218edd2c63"
  head "https://github.com/taem/cd-discid.git"

  bottle do
    cellar :any
    sha256 "0647971b092ef9505401fef5987a99ff3a9e4bc2956fc167899a85e9361c335b" => :yosemite
    sha256 "d16b9fb0eb3820f7531ce223e0e0c18ad85bb6e24020319151afff09e8d2e80f" => :mavericks
    sha256 "b12730d1530c45bce73cb6ae8cb7337c6063dea9d1fe50981111dd843269c1f1" => :mountain_lion
  end

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "cd-discid"
    man1.install "cd-discid.1"
  end

  test do
    assert_equal "cd-discid #{version}.", shell_output("#{bin}/cd-discid --version 2>&1").chomp
  end
end
