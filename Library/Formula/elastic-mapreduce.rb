require 'formula'

class ElasticMapreduce < Formula
  head 'http://github.com/tc/elastic-mapreduce-ruby.git'
  homepage 'http://developer.amazonwebservices.com/connect/entry.jspa?externalID=2264&categoryID=266'
  md5 'fd558dbe60ef41a1af2abc8e72123c93'
  version '2010-04-07'

  def install
    libexec.install Dir['*']
    bin.mkpath
    (bin + 'elastic-mapreduce').write shim_script('elastic-mapreduce')
  end
  
  def shim_script(target)
    <<-EOS.undent
      #!/bin/sh
      exec #{libexec}/#{target} $*
    EOS
  end
end
