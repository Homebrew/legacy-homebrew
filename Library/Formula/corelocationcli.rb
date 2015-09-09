class Corelocationcli < Formula
  desc "Prints location information from CoreLocation"
  homepage "https://github.com/fulldecent/corelocationcli"
  url "https://github.com/fulldecent/corelocationcli/archive/2.0.0.tar.gz"
  sha256 "d256ae0a534ef15f4b9a77704ef3bd52935c310a4f6a687657d79945c5544515"

  depends_on :xcode => :build

  def install
    xcodebuild "-project", "CoreLocationCLI.xcodeproj", "SYMROOT=build", "-sdk", "macosx#{MacOS.version}"
    bin.install "build/Release/CoreLocationCLI"
  end

  test do
    shell_output("#{bin}/CoreLocationCLI -h", 1)
  end
end
