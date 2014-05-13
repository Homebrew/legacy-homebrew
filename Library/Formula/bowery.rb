require 'formula'

class Bowery < Formula
  homepage 'http://bowery.io'
  url 'http://download.bowery.io/downloads/bowery_2.2.1_darwin_amd64.zip'
  version '2.2.1'
  sha1 'ecb1947c7507c6199d0de2316eca019f02db4e37'

  def install
    bin.install 'bowery'
  end
end
