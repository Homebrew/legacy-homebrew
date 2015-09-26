class MdaLv2 < Formula
  desc "LV2 port of the MDA plugins"
  homepage "http://drobilla.net/software/mda-lv2/"
  url "http://download.drobilla.net/mda-lv2-1.2.2.tar.bz2"
  sha256 "a476c31ed9f8b009ebacc32a02d06ba9584c0d0d03f03dd62b1354d10a030442"

  depends_on "pkg-config" => :build
  depends_on "lv2"

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--lv2dir=#{share}/lv2"
    system "./waf"
    system "./waf", "install"
  end
end
