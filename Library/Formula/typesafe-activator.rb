require 'formula'

class TypesafeActivator < Formula
  homepage 'http://typesafe.com/activator'
  url 'http://downloads.typesafe.com/typesafe-activator/1.0.0/typesafe-activator-1.0.0.zip'
  sha1 '9bbe02637e15f401fab28fcfbb038c43c17fbeba'

  def install
    system "./framework/build", "publish-local"

    # remove Windows .bat files
    rm Dir['*.bat']
    rm Dir["#{buildpath}/**/*.bat"]

    prefix.install_metafiles

    libexec.install Dir['*']
    bin.write_exec_script libexec/'activator'
  end
end
