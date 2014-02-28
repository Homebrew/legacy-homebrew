require 'formula'

class AppEngineJavaSdk < Formula
  homepage 'https://developers.google.com/appengine/docs/java/overview'
  url 'https://commondatastorage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.0.zip'
  sha1 '45fac6746c65641eeaf087c88bc755365c69ef71'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
