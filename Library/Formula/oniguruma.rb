class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v5.9.6/onig-5.9.6.tar.gz"
  sha256 "d5642010336a6f68b7f2e34b1f1cb14be333e4d95c2ac02b38c162caf44e47a7"

  bottle do
    cellar :any
    revision 1
    sha256 "653e3734097028be0863cdab51a8d3c92c1e3206cfec50072c18ab9e4e36bfc3" => :el_capitan
    sha256 "6a645e4c7bcf88d3d50aee632de816d884af7edf094fe793b451256e55bb8531" => :yosemite
    sha256 "ed3f1ef356a9dcae1ffff0b9bd853314b07289dfacdbf6b403515bcd35233227" => :mavericks
    sha256 "5a2ac152702eea6000bfa493607393f610fbec9684f1852cceb87834f20c9321" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
