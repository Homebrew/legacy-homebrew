require 'formula'

class VirtualhostSh < Formula
  url 'https://github.com/pgib/virtualhost.sh/tarball/e21da0342260d1d7704851ea1deef2856881921b'
  homepage 'https://github.com/pgib/virtualhost.sh'
  version 1.29
  sha1 '3c86c1bf44260e91d1590b683cd64066aa384199'

  head 'https://github.com/pgib/virtualhost.sh.git'

  def install
    bin.install 'virtualhost.sh'
  end
end
