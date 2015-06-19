require 'formula'

class Timedog < Formula
  desc "Lists files that were saved by a backup of the OS X Time Machine"
  homepage 'http://timedog.googlecode.com/'
  url 'https://timedog.googlecode.com/files/timedog-1.3.zip'
  sha1 'bacb349f0f81b5cb00fbabaff13fc643ba15e331'

  def install
    bin.install 'timedog'
  end
end
