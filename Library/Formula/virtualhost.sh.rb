require 'formula'

class VirtualhostSh < Formula
  desc "Script for OS X to create Apache virtual hosts"
  homepage 'https://github.com/virtualhost/virtualhost.sh'
  url 'https://github.com/virtualhost/virtualhost.sh/archive/1.34.tar.gz'
  sha1 '0f4a547b64b85e6b4547b865d30ab52c1f49cfd3'

  head 'https://github.com/virtualhost/virtualhost.sh.git'

  def install
    bin.install 'virtualhost.sh'
  end
end
