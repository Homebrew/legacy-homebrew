require 'formula'

class TypesafeActivator < Formula
  homepage 'https://typesafe.com/activator'
  url 'https://downloads.typesafe.com/typesafe-activator/1.3.0/typesafe-activator-1.3.0.zip'
  sha1 '7980f77c70ddc933a099cd3d0e1de24373386a0a'

  def install
    rm Dir["*.bat"] # Remove Windows .bat files
    prefix.install_metafiles
    libexec.install Dir['*']
    chmod 0755, libexec/'activator'
    bin.write_exec_script libexec/'activator'
  end
end
