require 'formula'

class VirtualhostSh < Formula
  url 'https://github.com/pgib/virtualhost.sh/tarball/1.23'
  homepage 'https://github.com/pgib/virtualhost.sh'
  sha1 '837eac3163de16c83f94a1f4e5e6c8c24aa65bc8'

  head 'https://github.com/pgib/virtualhost.sh.git'

  def install
    bin.install 'virtualhost.sh'
  end
end
