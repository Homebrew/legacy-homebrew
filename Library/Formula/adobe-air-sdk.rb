require "formula"

# Find downloads at:
# https://helpx.adobe.com/air/kb/archived-air-sdk-version.html
class AdobeAirSdk < Formula
  homepage "http://adobe.com/products/air/sdk"
  version "13.0"

  option "with-flex-support", "Do not download the new compiler with the SDK."

  if build.without? "flex-support"
    url "http://airdownload.adobe.com/air/mac/download/13.0/AIRSDK_Compiler.tbz2"
    sha1 "b3f15e01bb4f2ec4d82151257672156aa49f3ba8"
  else
    url "http://airdownload.adobe.com/air/mac/download/13.0/AdobeAIRSDK.tbz2"
    sha1 "dfbdde7e7de31804ad3d74df9f0ba71c5cf5c2ad"
  end

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
