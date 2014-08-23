require "formula"

class Libpng < Formula
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sf.net/project/libpng/libpng16/1.6.13/libpng-1.6.13.tar.xz"
  sha1 "5ae32b6b99cef6c5c85feab8edf9d619e1773b15"

  bottle do
    cellar :any
    sha1 "6b82dd8fc966b83b15ab27224f864a384b7b766d" => :mavericks
    sha1 "7136c93b5cdc9acc6fd777bb17668e272a7ba55d" => :mountain_lion
    sha1 "2672437209e1207f51135d8e8efa1db5a4852499" => :lion
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
