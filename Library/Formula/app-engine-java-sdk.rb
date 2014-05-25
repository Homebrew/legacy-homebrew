require 'formula'

class AppEngineJavaSdk < Formula
  homepage 'https://developers.google.com/appengine/docs/java/gettingstarted/introduction'
  url 'https://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.5.zip'
  sha1 'b662c48b932c7c10fa634c25e64adc62f7c66ddf'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
