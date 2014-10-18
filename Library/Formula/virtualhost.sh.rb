require 'formula'

class VirtualhostSh < Formula
  homepage 'https://github.com/virtualhost/virtualhost.sh'
  url 'https://github.com/virtualhost/virtualhost.sh/archive/1.32.tar.gz'
  sha1 '6f62cf860a260db876bd1ce21fbc523c0c0b6ea1'

  head 'https://github.com/virtualhost/virtualhost.sh.git'

  def install
    bin.install 'virtualhost.sh'
  end
end
