class SsllabsScan < Formula
  desc "This tool is a command-line client for the SSL Labs APIs."
  homepage "https://github.com/ssllabs/ssllabs-scan/"
  url "https://github.com/ssllabs/ssllabs-scan/archive/v1.3.0.tar.gz"
  sha256 "ec631177900ff07e1299e116638346e4ae95c878cfd317e9e1e8dfd73ecde514"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f660edbae6c6f1118772643c7eff3f352086b02f04bf07a9a1149a5777791f2" => :el_capitan
    sha256 "403869d861c3d5806352f34a2462af4f18f1dc55ad721ec6cc24be98c7e3af8a" => :yosemite
    sha256 "c45c6c3e884e18ad5636b7dac8276ebc808f224c13e3c3a6f328dd9b5a083d68" => :mavericks
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
