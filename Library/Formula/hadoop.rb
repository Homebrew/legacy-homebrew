require 'formula'

class Hadoop < Formula
  homepage 'http://hadoop.apache.org/common/'
  url 'http://www.apache.org/dyn/closer.cgi?path=hadoop/core/hadoop-2.0.1-alpha/hadoop-2.0.1-alpha.tar.gz'
  sha1 '233db02749dac6bed3331d7b871d793cb91f99ba'
  version '2.0.1'
  
  depends_on 'protobuf'
  
  def shim_script target
    <<-EOS.undent
    #!/bin/bash
    exec "#{libexec}/bin/#{target}" "$@"
    EOS
  end

  def install
    libexec.install %w[bin lib libexec share]
    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end
  end
  
  def test
    system "hadoop", "version"
  end
end
