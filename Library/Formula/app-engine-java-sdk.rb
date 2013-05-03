require 'formula'

class AppEngineJavaSdk < Formula
  homepage 'https://developers.google.com/appengine/docs/java/overview'
  url 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.7.7.zip'
  sha1 '088a996e237e65f7aa9ece9323fb005da44c0173'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.write_exec_script "#{libexec}/bin/*"
  end
end
