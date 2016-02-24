class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "http://drobilla.net/software/lilv/"
  url "http://download.drobilla.net/lilv-0.22.0.tar.bz2"
  sha256 "cd279321223ef11ca01551767d3c16d68cb31f689e02320a0b2e37b4f7d17ab4"

  bottle do
    cellar :any
    sha256 "d85d88a631e6a1d44a625e627b1baa83184c1079165681dc5484a61ccb9caa34" => :el_capitan
    sha256 "298450b7a9438d76ae68372458671736db651ee86fe9ae9ad46fd714df87cb73" => :yosemite
    sha256 "94f3da678e5ace390aa9b397dc77113956664ebb37c5b41831147404ee0923ba" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
