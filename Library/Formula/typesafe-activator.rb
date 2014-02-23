require 'formula'

class TypesafeActivator < Formula
  homepage 'http://typesafe.com/activator'
  url 'http://downloads.typesafe.com/typesafe-activator/1.0.13/typesafe-activator-1.0.13.zip'
  sha1 '34e655823a7931c7f61a978c7d9cbd20881267ac'

  def install
    # remove Windows .bat files
    rm Dir['*.bat']
    rm Dir["#{buildpath}/**/*.bat"]

    prefix.install_metafiles

    libexec.install Dir['*']
    bin.write_exec_script libexec/'activator'
  end
end
