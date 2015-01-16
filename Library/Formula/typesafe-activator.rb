require 'formula'

class TypesafeActivator < Formula
  homepage 'https://typesafe.com/activator'
  url 'http://downloads.typesafe.com/typesafe-activator/1.2.12/typesafe-activator-1.2.12.zip'
  sha1 '31a7ad0ccbbb9308150e9bf5df98e632c3293cb7'

  def install
    rm Dir["*.bat"] # Remove Windows .bat files
    prefix.install_metafiles
    libexec.install Dir['*']
    bin.write_exec_script libexec/'activator'
  end
end
