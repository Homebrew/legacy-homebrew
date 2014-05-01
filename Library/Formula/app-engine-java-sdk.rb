require 'formula'

class AppEngineJavaSdk < Formula
  homepage 'https://developers.google.com/appengine/docs/java/gettingstarted/introduction'
  url 'https://commondatastorage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.4.zip'
  sha1 'c8649a3c834d3aade93053ad52209d36780c292d'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
