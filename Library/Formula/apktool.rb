class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.0.2.jar", :using => :nounzip
  sha256 "c15cf1b87486d83dbc9e5ce64a03178a64eeeecf62cf08637193ba759f61419b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c90dd13af012a5921977bf100bd53f68cc1b29ca6a5eac25af731bc0a47a6b89" => :el_capitan
    sha256 "ffc20fe7e42429a059198a34aa267b03901c416b4a8c5729a565d35637111d12" => :yosemite
    sha256 "17733334df7798014a01a6b59cc484544fd42bce63bd242f26561831619286d1" => :mavericks
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
