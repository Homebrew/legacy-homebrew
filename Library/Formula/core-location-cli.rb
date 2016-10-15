class CoreLocationCli < Formula
  desc "Prints location information from CoreLocation"
  homepage "https://github.com/fulldecent/corelocationcli"
  url "https://github.com/fulldecent/corelocationcli/archive/v1.0.0.tar.gz"
  sha256 "a620192de33d5626832a9eac55a214f59bbf24c992bdde9a9626e9a97be696b9"

  depends_on :xcode => :build

  def install
    xcodebuild "-project", "CoreLocationCLI.xcodeproj", "SYMROOT=build", "-sdk", "macosx#{MacOS.version}"
    bin.install "build/Release/CoreLocationCLI"
  end

  test do
    system "#{bin}/CoreLocationCLI", "-h"
  end
end
