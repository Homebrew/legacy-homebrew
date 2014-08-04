require 'formula'

class TypesafeActivator < Formula
  homepage 'http://typesafe.com/activator'
  url 'http://downloads.typesafe.com/typesafe-activator/1.2.3/typesafe-activator-1.2.3.zip'
  sha1 '8cbdeb093e8b56ed16c6baad0c3d08a118c31c8a'

  def install
    rm Dir["*.bat"] # Remove Windows .bat files
    prefix.install_metafiles
    libexec.install Dir['*']
    bin.write_exec_script libexec/'activator'
  end
end
