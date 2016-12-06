require 'formula'

class Whirr < Formula
  homepage 'http://whirr.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=whirr/whirr-0.7.1/whirr-0.7.1.tar.gz'
  sha1 '15772fd7bf35cbc1c50023f4a22bcbb1cd1f80c9'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/bin/#{target}" "$@"
    EOS
  end

  def install
    libexec.install %w[bin conf lib]
    #bin.install Dir['bin/whirr']

    bin.mkpath
    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end
  end
end
