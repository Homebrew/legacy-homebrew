require 'formula'

class Ringojs < Formula
  url 'https://github.com/downloads/ringo/ringojs/ringojs-0.8.tar.gz'
  homepage 'http://ringojs.org'
  sha1 '28fd76fce28b41e2abcbe27a8b1731744d340e94'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      "#{libexec}/bin/#{target}" "$@"
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
