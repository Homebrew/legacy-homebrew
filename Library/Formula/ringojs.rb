require 'formula'

class Ringojs <Formula
  url 'http://github.com/downloads/ringo/ringojs/ringojs-0.5.tar.gz'
  homepage 'http://ringojs.org'
  md5 'ef79b9f6840d68842f4fbc1f466807f5'

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
