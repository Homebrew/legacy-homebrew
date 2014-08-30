require "formula"

# Find downloads at:
# https://helpx.adobe.com/air/kb/archived-air-sdk-version.html
class AdobeAirSdk < Formula
  homepage "http://adobe.com/products/air/sdk"
  version "14.0"

  option "with-flex-support", "Do not download the new compiler with the SDK."

  if build.without? "flex-support"
    url "http://airdownload.adobe.com/air/mac/download/14.0/AIRSDK_Compiler.tbz2"
    sha1 "56ab363187989de85cfcb0bdfe474a70f2de80fc"
  else
    url "http://airdownload.adobe.com/air/mac/download/14.0/AdobeAIRSDK.tbz2"
    sha1 "a46ff75f96694c710f96c03649f0e4cb6abb1c82"
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    To set AIR_HOME:
      export AIR_HOME=#{libexec}
    EOS
  end
end
