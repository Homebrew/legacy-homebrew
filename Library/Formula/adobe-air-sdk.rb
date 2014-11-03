require "formula"

# Find downloads at:
# https://helpx.adobe.com/air/kb/archived-air-sdk-version.html
class AdobeAirSdk < Formula
  homepage "http://adobe.com/products/air/sdk"
  version "15.0.0.302"

  option "with-flex-support", "Do not download the new compiler with the SDK."

  if build.without? "flex-support"
    url "http://airdownload.adobe.com/air/mac/download/15.0/AIRSDK_Compiler.tbz2"
    sha1 "5f6f647a6399c8ba501b9c6f6cda489bf50e0ba8"
  else
    url "http://airdownload.adobe.com/air/mac/download/15.0/AdobeAIRSDK.tbz2"
    sha1 "ce9a96ccc7a4a414ba7ef0eebf39a8a1150d228e"
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
