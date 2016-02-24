class DarkMode < Formula
  desc "Toggle the Dark Mode (in OS X 10.10) from the command-line"
  homepage "https://github.com/sindresorhus/dark-mode"
  url "https://github.com/sindresorhus/dark-mode/archive/1.0.1.tar.gz"
  sha256 "7c71d865ad1a058c98909b442cdeef6b95be62313909c176a9e58db0a7512902"
  head "https://github.com/sindresorhus/dark-mode.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "15ffc6e8d672a7601462f3597b5ca26b7ef5d2ce739ea7afa78e0cad23bee49e" => :el_capitan
    sha256 "f58b190cb89027daaea97e8cdc31bc4f097c51fef33e805751a1aef797871e5f" => :yosemite
  end

  depends_on :macos => :yosemite
  depends_on :xcode => :build

  def install
    xcodebuild "install",
               "SYMROOT=build",
               "DSTROOT=#{prefix}",
               "INSTALL_PATH=/bin",
               "ONLY_ACTIVE_ARCH=YES"
  end

  test do
    system "#{bin}/dark-mode", "--mode"
  end
end
