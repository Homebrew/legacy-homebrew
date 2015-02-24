require "formula"

# Find downloads at:
# https://helpx.adobe.com/air/kb/archived-air-sdk-version.html
class AdobeAirSdk < Formula
  homepage "http://adobe.com/products/air/sdk"
  version "16.0.0.272"

  option "with-flex-support", "Do not download the new compiler with the SDK."

  if build.without? "flex-support"
    url "http://airdownload.adobe.com/air/mac/download/16.0/AIRSDK_Compiler.tbz2"
    sha1 "ee487b3c0456ba825dd6af48682ba81802ef0300"
  else
    url "http://airdownload.adobe.com/air/mac/download/16.0/AdobeAIRSDK.tbz2"
    sha1 "65b0bf2163cb99566484bbebc65d4cf8cb8af898"
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
