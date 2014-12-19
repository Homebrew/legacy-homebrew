require "formula"

# Find downloads at:
# https://helpx.adobe.com/air/kb/archived-air-sdk-version.html
class AdobeAirSdk < Formula
  homepage "http://adobe.com/products/air/sdk"
  version "15.0.0.356"

  option "with-flex-support", "Do not download the new compiler with the SDK."

  if build.without? "flex-support"
    url "http://airdownload.adobe.com/air/mac/download/15.0/AIRSDK_Compiler.tbz2"
    sha1 "3e80a9daa5e029f4b9a79ded3faa517a649e90b4"
  else
    url "http://airdownload.adobe.com/air/mac/download/15.0/AdobeAIRSDK.tbz2"
    sha1 "47af192cebce5c08fcdde6bcc14aed5941a9ca85"
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
