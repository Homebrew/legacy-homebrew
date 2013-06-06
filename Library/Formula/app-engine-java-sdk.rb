require 'formula'

class AppEngineJavaSdk < Formula
  homepage 'https://developers.google.com/appengine/docs/java/overview'
  url 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.8.0.zip'
  sha1 '9efe79a91b1c07a032cd6bba58138b509dbb305d'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.write_exec_script "#{libexec}/bin/*"
  end
end
