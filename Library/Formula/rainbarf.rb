require 'formula'

class Rainbarf < Formula
  homepage 'https://github.com/creaktive/rainbarf'
  url 'https://github.com/creaktive/rainbarf/archive/v0.6.tar.gz'
  sha1 '46102cc165c3bd27bc7f798d2644b3c7e5be7f81'

  def install
    system 'pod2man', 'rainbarf', 'rainbarf.1'
    man1.install 'rainbarf.1'
    bin.install 'rainbarf'
  end
end
