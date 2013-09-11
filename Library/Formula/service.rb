require 'formula'
class Service < Formula
  version '0.2.0'
  homepage 'https://github.com/owahab/brew-services'
  url 'https://github.com/owahab/brew-services/archive/master.zip'
  sha1 '38fa629cc5e1856b39246ea99b07fc23225b170a'
  def install
    bin.install 'service'
  end
end