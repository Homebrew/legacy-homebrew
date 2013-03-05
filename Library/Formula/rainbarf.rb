require 'formula'

class Rainbarf < Formula
  homepage 'https://github.com/creaktive/rainbarf'
  url 'https://github.com/creaktive/rainbarf/archive/v0.7.tar.gz'
  sha1 'a32ec6bf19432b99a2d2860401da68939f539b2e'

  def install
    system 'pod2man', 'rainbarf', 'rainbarf.1'
    man1.install 'rainbarf.1'
    bin.install 'rainbarf'
  end
end
