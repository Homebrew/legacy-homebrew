require 'formula'

class AppEngineJavaSdk < Formula
  homepage 'https://developers.google.com/appengine/docs/java/overview'
  url 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.8.5.zip'
  sha1 '1fd19eed87d5442b7c3fc434d77a458937424284'

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']
    bin.write_exec_script "#{libexec}/bin/*"
  end
end
