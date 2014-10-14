require 'formula'

class VirtualhostSh < Formula
  homepage 'https://github.com/virtualhost/virtualhost.sh'
  url 'https://github.com/virtualhost/virtualhost.sh/archive/1.31.tar.gz'
  sha1 '25954027dbed14843123bea4efd498cd2abfc4a0'

  head 'https://github.com/virtualhost/virtualhost.sh.git'

  def install
    bin.install 'virtualhost.sh'
  end
end
