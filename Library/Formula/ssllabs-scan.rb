class SsllabsScan < Formula
  desc "This tool is a command-line client for the SSL Labs APIs."
  homepage "https://github.com/ssllabs/ssllabs-scan/"
  url "https://github.com/ssllabs/ssllabs-scan/archive/v1.2.0.tar.gz"
  sha256 "c8becd57a4aa65f5c4c32824e392d8373ae169ff055192107e9411032dfcd017"

  bottle do
    cellar :any_skip_relocation
    sha256 "25db5e475aa97258a5012a41ae8b54a152ce58cf148609c4d276492158fdbb7f" => :el_capitan
    sha256 "16583421f5bb71ec82b174e82675462d832dcd18768e54b5ce931040b100473b" => :yosemite
    sha256 "369c25ecefbea1e9cd09783b9a5c57120c9e2d7f0fa80967e912a77c5e37771a" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "make", "build"
    bin.install "ssllabs-scan"
  end

  def caveats; <<-EOS.undent
    By installing this package you agree to the Terms and Conditions defined by Qualys.
    You can find the terms and conditions at this link:
       https://www.ssllabs.com/about/terms.html

    If you do not agree with those you should uninstall the formula.
  EOS
  end

  test do
    system "#{bin}/ssllabs-scan", "-grade", "-quiet", "-usecache", "ssllabs.com"
  end
end
