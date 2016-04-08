class TypesafeActivator < Formula
  desc "Tools for working with Lightbend Reactive Platform"
  homepage "https://lightbend.com/activator"
  url "https://downloads.lightbend.com/typesafe-activator/1.3.9/typesafe-activator-1.3.9-minimal.zip"
  version "1.3.9"
  sha256 "a418cdc7f204aca9cc8777df6d3a18c1bae1157fd972d60d135fce43e217cd64"

  bottle :unneeded

  def install
    rm Dir["*.bat"] # Remove Windows .bat files
    libexec.install Dir["*"]
    chmod 0755, libexec/"activator"
    bin.write_exec_script libexec/"activator"
  end
end
