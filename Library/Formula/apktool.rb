class Apktool < Formula
  homepage "https://github.com/iBotPeaches/Apktool"
  url "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.0.0.jar", :using => :nounzip
  sha256 "0dd25996d8e23d8efcca0872dab6498af6f97c5e6cdef10005f5d82a7636f57d"

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
