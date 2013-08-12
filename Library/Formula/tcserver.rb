require 'formula'

class Tcserver < Formula
  homepage 'http://www.gopivotal.com/?q=pivotal-products/pivotal-application-cloud-fabric/pivotal-tc-server'
  url 'http://public.pivotal.com.s3.amazonaws.com/releases/tcserver/2.9.3.RELEASE/tcserver-2.9.3.RELEASE-developer.tar.gz'
  sha1 '2c4b412aa5c78c03a0193e13eb6eb44304dd21a7'
  version "2.9.3"

  def install
    # Remove Windows scripts
    rm_rf Dir['**/*.bat']

    # Install files
    prefix.install %w{ README.txt licenses/VMware_EULA_20120515b_English.txt licenses/vfabric-tc-server-developer-open-source-licenses-2.9.3.RELEASE.txt}
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/*.sh"]
  end

  def caveats; <<-EOS.undent
    By installing, you agree to comply with the license at http://www.gopivotal.com/pivotal-community-edition-software-license-agreement. If you disagree with these terms, please uninstall by typing "brew uninstall tcserver" in your terminal window.
    EOS
  end
end
