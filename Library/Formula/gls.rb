class Gls < Formula
  desc "Graphical \"ls\" command for iTerm2"
  homepage "https://github.com/rs/gls"
  head "https://github.com/rs/gls/archive/master.zip"
  url "https://github.com/rs/gls/archive/1.0.tar.gz"
  sha256 "2c8fcd7c964b8c9d62dd20cb7c719b736800f23c5aa9d657995f33cedb149f1b"

  depends_on :xcode => :build

  def install
    xcodebuild "-project", "gls.xcodeproj", "SYMROOT=build"
    bin.install "build/Release/gls"
  end

  test do
    system "#{bin}/gls"
  end
end
