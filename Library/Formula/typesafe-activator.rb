class TypesafeActivator < Formula
  desc "Tools for working with Typesafe Reactive Platform"
  homepage "https://typesafe.com/activator"
  version "1.3.6"
  url "https://downloads.typesafe.com/typesafe-activator/1.3.6/typesafe-activator-1.3.6-minimal.zip"
  sha256 "3fc80ea6f4068955db65d1355ccc06a1f7e1a0ff05d71dd0861fb30cea415512"

  def install
    rm Dir["*.bat"] # Remove Windows .bat files
    prefix.install_metafiles
    libexec.install Dir["*"]
    chmod 0755, libexec/"activator"
    bin.write_exec_script libexec/"activator"
  end
end
