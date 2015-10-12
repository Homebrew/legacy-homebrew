class Corelocationcli < Formula
  desc "Prints location information from CoreLocation"
  homepage "https://github.com/fulldecent/corelocationcli"
  url "https://github.com/fulldecent/corelocationcli/archive/2.0.0.tar.gz"
  sha256 "d256ae0a534ef15f4b9a77704ef3bd52935c310a4f6a687657d79945c5544515"

  bottle do
    cellar :any
    sha256 "db59b11dcbcef4e71fc43eb005fe855d6e19e0108e2c8ceb3378b306f3d82e35" => :yosemite
    sha256 "ffd7a23f96ef1b732fb4873b8d26b51fa183a9eea4f2fd0805ed7a54d5d61e9b" => :mavericks
    sha256 "e0a967b5f84f3b1d4bc799265f3692faab41ccf7f673749624051a8d87516389" => :mountain_lion
  end

  depends_on :xcode => :build

  def install
    xcodebuild "-project", "CoreLocationCLI.xcodeproj", "SYMROOT=build", "-sdk", "macosx#{MacOS.version}"
    bin.install "build/Release/CoreLocationCLI"
  end

  test do
    shell_output("#{bin}/CoreLocationCLI -h", 1)
  end
end
