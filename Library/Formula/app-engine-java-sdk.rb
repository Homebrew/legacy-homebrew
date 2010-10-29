require 'formula'

class AppEngineJavaSdk <Formula
  url 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.3.8.zip'
  homepage 'http://code.google.com/appengine/docs/java/overview.html'
  sha1 '5395bb75ab8913ec2312e0cd65815e04858e3d33'

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
