require 'formula'

class Timedog < Formula
  homepage 'http://timedog.googlecode.com/'
  url 'http://timedog.googlecode.com/files/timedog-1.3.zip'
  sha1 'bacb349f0f81b5cb00fbabaff13fc643ba15e331'

  def install
    bin.install 'timedog'
  end
end
