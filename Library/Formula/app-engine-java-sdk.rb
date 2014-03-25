require 'formula'

class AppEngineJavaSdk < Formula
  homepage 'https://developers.google.com/appengine/docs/java/gettingstarted/introduction'
  url 'https://commondatastorage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.1.zip'
  sha1 'e2bcbf981b3ebcb0639b818e201fe220cadc51d5'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
