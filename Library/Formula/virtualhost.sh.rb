class VirtualhostSh < Formula
  desc "Script for OS X to create Apache virtual hosts"
  homepage "https://github.com/virtualhost/virtualhost.sh"
  url "https://github.com/virtualhost/virtualhost.sh/archive/1.35.tar.gz"
  sha256 "75d34b807e71acd253876c6a99cdbc11ce31ffb159155373c83a99af862fffcc"

  head "https://github.com/virtualhost/virtualhost.sh.git"

  def install
    bin.install "virtualhost.sh"
  end
end
