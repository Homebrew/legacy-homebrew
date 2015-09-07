class Gls < Formula
  desc "A graphical ls command for iTerm2"
  homepage "https://github.com/rs/gls"
  url "https://github.com/rs/gls/archive/1.0.tar.gz"
  sha256 "d5cb69827f57fd61d354418b08ff8ebf854e08daaeebb08aaa5a9d3450c06a54"
  depends_on :xcode => :build

  def install
    xcodebuild "-project", "gls.xcodeproj", "SYMROOT=build"
    bin.install "build/Release/gls"
  end
end
