require 'formula'

class Ringojs < Formula
  url 'https://github.com/downloads/ringo/ringojs/ringojs-0.6.tar.gz'
  homepage 'http://ringojs.org'
  md5 '9a18e2bc6624df43010c61d2ef0d65ee'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      #{libexec}/bin/#{target} $*
    EOS
  end

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']

    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end
  end
end
