require 'formula'

class TypesafeActivator < Formula
  homepage 'http://typesafe.com/activator'
  url 'http://downloads.typesafe.com/typesafe-activator/1.2.6/typesafe-activator-1.2.6.zip'
  sha1 'e024bfe90a76d308e68fd46952f8c212c15542d1'

  def install
    rm Dir["*.bat"] # Remove Windows .bat files
    prefix.install_metafiles
    libexec.install Dir['*']
    bin.write_exec_script libexec/'activator'
  end
end
