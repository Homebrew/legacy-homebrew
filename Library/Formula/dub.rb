class Dub < Formula
  homepage "http://code.dlang.org/about"
  url  "https://github.com/D-Programming-Language/dub/archive/v0.9.23.tar.gz"
  sha1 "88c908cab5d396435091cb9cc31dcd886fdb26c9"

  head "https://github.com/D-Programming-Language/dub.git", :shallow => false

  depends_on "pkg-config" => :build
  depends_on "dmd" => :build

  def install
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    system "#{bin}/dub; true"
  end
end
