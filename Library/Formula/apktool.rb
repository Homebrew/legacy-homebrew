class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.0.3.jar", :using => :nounzip
  sha256 "ceca3e49bfc697c918aaff160c28244f27a2c1c741af62a70e1558a066a16dd3"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7a126b2f51d9bb040d4ed3e65927af3c59d729ae5ff4db632ae99d5b1360a78" => :el_capitan
    sha256 "e381c8bfa9be3f6c0698a8ae55d8be96e0d68acf372d410b3e5460122a3933ea" => :yosemite
    sha256 "07acb5961b0ee3174ed381157cfc38e7644cb8582c207a519e00ef41e7c4b74b" => :mavericks
  end

  resource "sample.apk" do
    url "https://github.com/downloads/stephanenicolas/RoboDemo/robodemo-sample-1.0.1.apk", :using => :nounzip
    sha256 "bf3ec04631339538c8edb97ebbd5262c3962c5873a2df9022385156c775eb81f"
  end

  def install
    libexec.install "apktool_#{version}.jar"
    bin.write_jar_script libexec/"apktool_#{version}.jar", "apktool"
  end

  test do
    resource("sample.apk").stage do
      system "#{bin}/apktool", "d", "robodemo-sample-1.0.1.apk"
      system "#{bin}/apktool", "b", "robodemo-sample-1.0.1"
    end
  end
end
