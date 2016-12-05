require 'formula'

class Rapidjson < Formula
  homepage 'http://code.google.com/p/rapidjson/'
  url 'https://rapidjson.googlecode.com/files/rapidjson-0.11.zip'
  sha1 '3348f4ce925ee0e58da123abfafe09ba203d4fc3'

  def install
     prefix.install Dir['include']
  end
end
