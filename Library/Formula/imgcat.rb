class Imgcat < Formula
  desc "iTerm's imgcat"
  homepage "https://www.iterm2.com/images.html"
  url "https://raw.githubusercontent.com/gnachman/iTerm2/7fb596f04b8e8c7e730efe1a033317f121a2f943/tests/imgcat"
  version "2.9"
  sha256 "036ee8aec2487a02b40d62d72918090ae022fc018589337dfd8403e08ffdd0c0"

  head do 
    url "https://raw.githubusercontent.com/gnachman/iTerm2/HEAD/tests/imgcat", :using => :curl
  end

  def install
    bin.install "imgcat"
  end

  test do
    system "#{bin}/imgcat", test_fixtures("test.png")
  end
end
