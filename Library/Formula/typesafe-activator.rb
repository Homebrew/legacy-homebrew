require 'formula'

class TypesafeActivator < Formula
  homepage 'https://typesafe.com/activator'
  url 'https://downloads.typesafe.com/typesafe-activator/1.3.2/typesafe-activator-1.3.2.zip'
  sha1 'b222c96b082fe6e74e03e455fe3103817391f003'

  def install
    rm Dir["*.bat"] # Remove Windows .bat files
    prefix.install_metafiles
    libexec.install Dir['*']
    chmod 0755, libexec/'activator'
    bin.write_exec_script libexec/'activator'
  end
end
