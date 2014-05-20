require "formula"

class Sxiv < Formula
  homepage "https://github.com/muennich/sxiv"
  url "https://github.com/muennich/sxiv/archive/v1.2.tar.gz"
  sha1 "69cacabdd60316edbf3eee076d8057df7f7be0ed"

  head "https://github.com/muennich/sxiv.git"

  depends_on :x11
  depends_on "imlib2"
  depends_on "giflib"

  def install
    system "make", "config.h"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/sxiv", "-v"
  end
end
