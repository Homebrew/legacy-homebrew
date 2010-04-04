require 'formula'

class AppEngineJavaSdk <Formula
  @url='http://googleappengine.googlecode.com/files/appengine-java-sdk-1.3.2.zip'
  @homepage='http://code.google.com/appengine/docs/java/overview.html'
  @sha1='175612837051384870dca591b9c61863714ffafc'

  def install
    prefix.install Dir['*']
  end
end
