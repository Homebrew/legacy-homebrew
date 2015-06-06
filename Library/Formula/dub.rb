class Dub < Formula
  desc "Build tool for D projects"
  homepage "http://code.dlang.org/about"
  url  "https://github.com/D-Programming-Language/dub/archive/v0.9.23.tar.gz"
  sha1 "88c908cab5d396435091cb9cc31dcd886fdb26c9"

  bottle do
    sha256 "e2613efeb8173e8f1beb2a4b1bf14baa70a4fa7781919c87be435bb1d55d8ae2" => :yosemite
    sha256 "b108a54497cf52eb62d4aad877804630a26d47b59e606d300e7becb3a98be877" => :mavericks
    sha256 "4afe785f25db496f8634c19211d68c7ea05778f9ed1e7e772f8aa9ac701beca1" => :mountain_lion
  end

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
