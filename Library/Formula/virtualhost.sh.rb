require 'formula'

class VirtualhostSh < Formula
  homepage 'https://github.com/pgib/virtualhost.sh'
  url 'https://github.com/pgib/virtualhost.sh/archive/1.30.tar.gz'
  sha1 '0de462c1ec15c4dfcd2b73d806394bc6b7f93e60'

  head 'https://github.com/pgib/virtualhost.sh.git'

  def install
    bin.install 'virtualhost.sh'
  end
end
