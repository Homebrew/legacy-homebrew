require 'formula'

class VirtualhostSh < Formula
  homepage 'https://github.com/virtualhost/virtualhost.sh'
  url 'https://github.com/virtualhost/virtualhost.sh/archive/1.32.tar.gz'
  sha1 'dc307937e10c2a5948c59ff2ece6495763415b77'

  head 'https://github.com/virtualhost/virtualhost.sh.git'

  def install
    bin.install 'virtualhost.sh'
  end
end
