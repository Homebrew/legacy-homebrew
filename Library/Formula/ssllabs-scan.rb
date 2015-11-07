class SsllabsScan < Formula
  desc "This tool is a command-line client for the SSL Labs APIs."
  homepage "https://github.com/ssllabs/ssllabs-scan/"
  url "https://github.com/ssllabs/ssllabs-scan/archive/v1.2.0.tar.gz"
  sha256 "c8becd57a4aa65f5c4c32824e392d8373ae169ff055192107e9411032dfcd017"

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
