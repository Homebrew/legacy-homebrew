require "formula"

# Find downloads at:
# https://helpx.adobe.com/air/kb/archived-air-sdk-version.html
class AdobeAirSdk < Formula
  homepage "http://adobe.com/products/air/sdk"
  version "15.0.0.249"

  option "with-flex-support", "Do not download the new compiler with the SDK."

  if build.without? "flex-support"
    url "http://airdownload.adobe.com/air/mac/download/15.0/AIRSDK_Compiler.tbz2"
    sha1 "8313d44ef53c02e271ddc7f59caeba5e7d910530"
  else
    url "http://airdownload.adobe.com/air/mac/download/15.0/AdobeAIRSDK.tbz2"
    sha1 "7d2dbf86c9bacf231bdc4b0d57db443c934d0294"
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
