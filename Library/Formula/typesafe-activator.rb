class TypesafeActivator < Formula
  desc "Tools for working with Typesafe Reactive Platform"
  homepage "https://typesafe.com/activator"
  url "https://downloads.typesafe.com/typesafe-activator/1.3.7/typesafe-activator-1.3.7-minimal.zip"
  version "1.3.7"
  sha256 "030cf23d3b68e588b44840a66aab82d2f927fe140eba46cce566cec5fc98c27c"

  bottle :unneeded

  def install
    rm Dir["*.bat"] # Remove Windows .bat files
    libexec.install Dir["*"]
    chmod 0755, libexec/"activator"
    bin.write_exec_script libexec/"activator"
  end
end
