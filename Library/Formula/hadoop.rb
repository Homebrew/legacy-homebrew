require 'formula'

class Hadoop < Formula
  url 'http://www.carfab.com/apachesoftware/hadoop/core/hadoop-0.20.2/hadoop-0.20.2.tar.gz'
  homepage 'http://hadoop.apache.org/common/'
  md5 '8f40198ed18bef28aeea1401ec536cb9'

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install %w[bin conf contrib lib]
  end
end
