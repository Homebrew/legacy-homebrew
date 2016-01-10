class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "http://docs.monome.org/doku.php?id=app:serialosc"
  url "https://github.com/monome/serialosc/archive/1.2.tar.gz"
  sha256 "9b4852b8ea402f2675b39bec98ec976fdd718f3295713743e3e898349e0f1b77"

  head "https://github.com/monome/serialosc.git"

  depends_on "liblo"
  depends_on "confuse"
  depends_on "libmonome"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf build"
    system "./waf install"
  end
end
