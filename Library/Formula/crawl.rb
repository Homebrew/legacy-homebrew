class Crawl < Formula
  desc "Dungeon Crawl: Stone Soup"
  homepage "http://crawl.develz.org/"
  url "https://github.com/crawl/crawl.git",
    :tag => "0.17.1",
    :revision => "942a3d2973debefdaddbf6291e4ebc890725b920"
  head "https://github.com/crawl/crawl.git"

  option "with-tiles", "Build with graphical tiles"

  depends_on "cmake" => :build

  def install
    args = [
      "APPLE_GCC=1",
      "prefix=#{prefix}",
      "DATADIR=#{prefix}",
    ]

    args << "NO_PKGCONFIG=y" << "CONTRIB_SDL=y" << "TILES=y" if build.with? "tiles"

    cd "crawl-ref/source" do
      system "make", "install", *args
    end
  end

  test do
    assert_match "Crawl version #{version}", shell_output("#{bin}/crawl -version")
  end
end
