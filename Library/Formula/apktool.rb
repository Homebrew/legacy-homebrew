class Apktool < Formula
  desc "Tool for reverse engineering 3rd party, closed, binary Android apps"
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.0.0.jar", :using => :nounzip
  sha256 "0dd25996d8e23d8efcca0872dab6498af6f97c5e6cdef10005f5d82a7636f57d"

  bottle do
    cellar :any
    sha256 "06bbdaf873a3737619a21dfd1b2028efb21e75578bee05d5085b4f4821c5d160" => :yosemite
    sha256 "b174b06b8504a9a3fd2d796d75cc0ab956cddf7e9b49cb1b4cc431f4e632956e" => :mavericks
    sha256 "2616c26534985cad55af50e2376ba4ff3540010f5ae66536d8036cd6acc44164" => :mountain_lion
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
