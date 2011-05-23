require 'formula'

class VirtualhostSh < Formula
  url 'git://github.com/pgib/virtualhost.sh.git', :tag => 1.23
  version "1.23"
  head 'git://github.com/pgib/virtualhost.sh.git'
  homepage 'https://github.com/pgib/virtualhost.sh'

  def install
    bin.install Dir['virtualhost.sh']
  end
end
