class TypesafeActivator < Formula
  homepage "https://typesafe.com/activator"
  version "1.3.4"
  url "https://downloads.typesafe.com/typesafe-activator/1.3.4/typesafe-activator-1.3.4-minimal.zip"
  sha256 "8c403e074165b8a73e75c60c897078ac90295d054dd16c462c2f9aab9413e031"

  def install
    rm Dir["*.bat"] # Remove Windows .bat files
    prefix.install_metafiles
    libexec.install Dir["*"]
    chmod 0755, libexec/"activator"
    bin.write_exec_script libexec/"activator"
  end
end
