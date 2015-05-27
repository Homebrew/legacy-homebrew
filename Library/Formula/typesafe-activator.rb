require 'formula'

class TypesafeActivator < Formula
  homepage 'https://typesafe.com/activator'
  version '1.3.3'
  url 'https://downloads.typesafe.com/typesafe-activator/1.3.3/typesafe-activator-1.3.3-minimal.zip'
  sha1 '4930cd73b2d5b7e263287419c75df5be293b210a'

  def install
    rm Dir["*.bat"] # Remove Windows .bat files
    prefix.install_metafiles
    libexec.install Dir['*']
    chmod 0755, libexec/'activator'
    bin.write_exec_script libexec/'activator'
  end
end
