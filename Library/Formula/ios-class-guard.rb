require "formula"

class IosClassGuard < Formula
  homepage "https://github.com/Polidea/ios-class-guard/"
  head "https://github.com/Polidea/ios-class-guard.git"
  url "https://github.com/Polidea/ios-class-guard/archive/0.6.tar.gz"
  sha1 "6b16fcb8ba55354180de7460d3ea1ae3cc4830ac"

  depends_on :macos => :mavericks
  depends_on :xcode => :build

  def install
    xcodebuild "-workspace", "ios-class-guard.xcworkspace", "-scheme", "ios-class-guard", "-configuration", "Release", "SYMROOT=build", "PREFIX=#{prefix}", "ONLY_ACTIVE_ARCH=YES"
    bin.install "build/Release/ios-class-guard"
  end

  test do
    (testpath/"crashdump").write <<-EOS.undent
      1   MYAPP                           0x0006573a -[C03B setR02:] + 42
    EOS
    (testpath/"symbols.json").write <<-EOS.undent
      {
        "C03B" : "MyViewController",
        "setR02" : "setRightButtons"
      }
    EOS
    system "#{bin}/ios-class-guard", "-c", "crashdump", "-m", "symbols.json"
  end
end
