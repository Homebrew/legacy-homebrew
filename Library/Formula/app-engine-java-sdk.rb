require 'formula'

class AppEngineJavaSdk < Formula
  homepage 'https://developers.google.com/appengine/docs/java/overview'
  url 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.8.4.zip'
  sha1 'ca7077793a1c7c4d078110416635c095eecde3f9'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.write_exec_script "#{libexec}/bin/*"
  end
end
