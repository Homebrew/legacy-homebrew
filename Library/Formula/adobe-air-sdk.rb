# Find downloads at:
# https://helpx.adobe.com/air/kb/archived-air-sdk-version.html
class AdobeAirSdk < Formula
  homepage "https://www.adobe.com/devnet/air/air-sdk-download.html"
  version "16.0.0.292"

  option "with-flex-support", "Do not download the new compiler with the SDK."

  if build.without? "flex-support"
    url "http://airdownload.adobe.com/air/mac/download/16.0/AIRSDK_Compiler.tbz2"
    sha1 "5ed2481de822e7f557db33c1bbff9b30e7df4735"
  else
    url "http://airdownload.adobe.com/air/mac/download/16.0/AdobeAIRSDK.tbz2"
    sha1 "3feaadf534f5f186286eb33cb4461d7e78cdb91d"
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
