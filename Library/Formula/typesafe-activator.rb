class TypesafeActivator < Formula
  desc "Tools for working with Typesafe Reactive Platform"
  homepage "https://typesafe.com/activator"
  version "1.3.5"
  url "https://downloads.typesafe.com/typesafe-activator/1.3.5/typesafe-activator-1.3.5-minimal.zip"
  sha256 "bafa6f3ab8078c446b9c019297fb8123c2987d934924160a3dbba95b8136f8ca"

  def install
    rm Dir["*.bat"] # Remove Windows .bat files
    prefix.install_metafiles
    libexec.install Dir["*"]
    chmod 0755, libexec/"activator"
    bin.write_exec_script libexec/"activator"
  end
end
