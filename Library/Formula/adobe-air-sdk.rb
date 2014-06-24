require "formula"

# Find downloads at:
# https://helpx.adobe.com/air/kb/archived-air-sdk-version.html
class AdobeAirSdk < Formula
  homepage "http://adobe.com/products/air/sdk"
  version "14.0"

  option "with-flex-support", "Do not download the new compiler with the SDK."

  if build.without? "flex-support"
    url "http://airdownload.adobe.com/air/mac/download/14.0/AIRSDK_Compiler.tbz2"
    sha1 "DE1F1C5CD74D52EAC4C0CAF447D9B659D1E23969"
  else
    url "http://airdownload.adobe.com/air/mac/download/14.0/AdobeAIRSDK.tbz2"
    sha1 "FFC5F4093FEB5A1CF2EFCB8854F2328593DB828C"
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
