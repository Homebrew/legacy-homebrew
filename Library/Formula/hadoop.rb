require 'formula'

class Hadoop < Formula
  url 'http://apache.dataphone.se/hadoop/core/hadoop-0.20.1/hadoop-0.20.1.tar.gz'
  homepage 'http://hadoop.apache.org/common/'
  md5 '719e169b7760c168441b49f405855b72'

  def install
    prefix.install %w[bin conf contrib lib]
    FileUtils.rm_f Dir["#{bin}/*.bat"]
  end
  
end
