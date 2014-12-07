require "formula"

class Clib < Formula
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.4.0.tar.gz"
  sha1 "75b8b04047150d9bdd492f2f1ffe50954555ba48"

  head "https://github.com/clibs/clib.git"

  bottle do
    cellar :any
    sha1 "f0819f6b6d7f177efe2b90811c6571b39a1ca8c0" => :yosemite
    sha1 "fd21c95f1441ace6e2706b891239581461143988" => :mavericks
    sha1 "256faa89ce64bdd17b3f19726dd0d0ca85dbcad6" => :mountain_lion
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
