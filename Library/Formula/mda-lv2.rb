class MdaLv2 < Formula
  desc "LV2 port of the MDA plugins"
  homepage "http://drobilla.net/software/mda-lv2/"
  url "http://download.drobilla.net/mda-lv2-1.2.2.tar.bz2"
  sha256 "a476c31ed9f8b009ebacc32a02d06ba9584c0d0d03f03dd62b1354d10a030442"

  bottle do
    cellar :any
    sha256 "a6715dce4c5c5cef40bd1a2645faf235ed044eb1dd64152381ebeb287625ff79" => :el_capitan
    sha256 "20351537b304e6d325220518442636df14906a89d0f1c653988d9134b75c5729" => :yosemite
    sha256 "1394acd4428272eeeee8285fe0e5272cb6db918ff18f74b020db147de3d3a71b" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
