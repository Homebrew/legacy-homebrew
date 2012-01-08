require 'formula'

class VirtualhostSh < Formula
  url 'https://github.com/pgib/virtualhost.sh/tarball/1.23'
  homepage 'https://github.com/pgib/virtualhost.sh'
  md5 'c64f7fa01abfae56853e8af39b3913cb'

  head 'https://github.com/pgib/virtualhost.sh.git'

  def install
    bin.install 'virtualhost.sh'
  end
end
