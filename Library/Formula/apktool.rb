class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.0.1.jar", :using => :nounzip
  sha256 "b1e840798b674ec59df870145ad91d866c6be7a17b5aef4fc2717f71a58224c4"

  bottle do
    cellar :any
    sha256 "e462eef4d9966d2a94a88505f8f663ae99f131d12cb133add4546dfd77f77055" => :yosemite
    sha256 "5eebe14f27945596c8359da9ae00bfe854c0258d91562e510e9f990b15dacc49" => :mavericks
    sha256 "2b8d737da9079807cd1ec03417506e204b2451cced096c26c1b2126ac2caec06" => :mountain_lion
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
