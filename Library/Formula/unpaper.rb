require "formula"

class Unpaper < Formula
  homepage "https://www.flameeyes.eu/projects/unpaper"
  url "https://www.flameeyes.eu/files/unpaper-5.1.tar.xz"
  sha1 "97068a99d47d1d65030c88d52058c1d5ff7b41d1"

  bottle do
    cellar :any
    sha1 "c20298eac668f11a24cb02a61065ad58096623bb" => :mavericks
    sha1 "dbad33b7762c589639ccf084d33776a55b777593" => :mountain_lion
    sha1 "1f0bdc89500234a96557d99cd2bcb6cc1372594e" => :lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
