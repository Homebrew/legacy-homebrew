class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "http://www.audiocoding.com/faac.html"
  url "https://downloads.sourceforge.net/project/faac/faac-src/faac-1.28/faac-1.28.tar.gz"
  sha1 "d00b023a3642f81bb1fb13d962a65079121396ee"

  bottle do
    cellar :any
    revision 1
    sha1 "46a8facbfd103d787d198e6fb802d6f0948222e0" => :yosemite
    sha1 "2a1e8a1decd52fcdf6498edd7f8437536d05d453" => :mavericks
    sha1 "9ea199f750c83887bb9e3d66759a60872672865f" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert File.exist?("test.m4a")
  end
end
