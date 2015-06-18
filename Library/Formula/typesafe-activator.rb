class TypesafeActivator < Formula
  desc "Tools for working with Typesafe Reactive Platform"
  homepage "https://typesafe.com/activator"
  version "1.3.5"
  url "https://downloads.typesafe.com/typesafe-activator/1.3.5/typesafe-activator-1.3.5-minimal.zip"
  sha256 "bafa6f3ab8078c446b9c019297fb8123c2987d934924160a3dbba95b8136f8ca"

  bottle do
    cellar :any
    sha256 "87147dc91da4acb0bc5fa83b89dba680c57ec16cf1e804c216415e1333a166f5" => :yosemite
    sha256 "f39c045255441c3b95408540baa7ae289c379027caec3b018827f4c23812ccd0" => :mavericks
    sha256 "b3658d20b1e5ee2d8df9c3fa87449a92a199a91ac8d35c9baeae8ba136099a92" => :mountain_lion
  end

  def install
    rm Dir["*.bat"] # Remove Windows .bat files
    prefix.install_metafiles
    libexec.install Dir["*"]
    chmod 0755, libexec/"activator"
    bin.write_exec_script libexec/"activator"
  end
end
