require 'formula'

class AppEngineJavaSdk < Formula
  homepage 'https://developers.google.com/appengine/docs/java/overview'
  url 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.7.6.zip'
  sha1 '5521e507ea90371b8f9eb842b5ec45d9bf2f7dc5'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.write_exec_script "#{libexec}/bin/*"
  end
end
