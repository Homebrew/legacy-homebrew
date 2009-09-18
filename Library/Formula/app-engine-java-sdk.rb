require 'brewkit'

class AppEngineJavaSdk <Formula
  @url='http://googleappengine.googlecode.com/files/appengine-java-sdk-1.2.5.zip'
  @homepage='http://code.google.com/appengine/docs/java/overview.html'
  @sha1='f0ef8454f72b550791ac856849e322054c4bc8f4'

  def install
    prefix.install Dir['*']
  end
end
