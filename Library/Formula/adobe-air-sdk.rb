require "formula"

# Find downloads at:
# https://helpx.adobe.com/air/kb/archived-air-sdk-version.html
class AdobeAirSdk < Formula
  homepage "http://adobe.com/products/air/sdk"
  version "14.0"

  option "with-flex-support", "Do not download the new compiler with the SDK."

  if build.without? "flex-support"
    url "http://airdownload.adobe.com/air/mac/download/14.0/AIRSDK_Compiler.tbz2"
    sha1 "e88f65c5c813f8000cb170cec1a7689695d2e797"
  else
    url "http://airdownload.adobe.com/air/mac/download/14.0/AdobeAIRSDK.tbz2"
    sha1 "ffc5f4093feb5a1cf2efcb8854f2328593db828c"
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
