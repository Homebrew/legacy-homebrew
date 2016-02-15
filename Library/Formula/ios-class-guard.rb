class IosClassGuard < Formula
  desc "Objective-C obfuscator for Mach-O executables"
  homepage "https://github.com/Polidea/ios-class-guard/"
  head "https://github.com/Polidea/ios-class-guard.git"
  url "https://github.com/Polidea/ios-class-guard/archive/0.8.tar.gz"
  sha256 "4446993378f1e84ce1d1b3cbace0375661e3fe2fa1a63b9bf2c5e9370a6058ff"

  bottle do
    cellar :any_skip_relocation
    sha256 "0bb9abaac82cbc4e66a12493548659197559a01a779db6ceda4cf6c4439ea0bb" => :el_capitan
    sha256 "4cada6d32bb82fbd8ad2afa58b7041bd5da12dc5d9fceab6277eec97459a2d33" => :yosemite
    sha256 "4eddde784c843628cb8bcb8c971142683c5a17373058f5bda62356b432dec00a" => :mavericks
  end

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
