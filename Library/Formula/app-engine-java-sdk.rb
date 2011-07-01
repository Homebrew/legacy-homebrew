require 'formula'

class AppEngineJavaSdk < Formula
  url 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.5.1.zip'
  homepage 'http://code.google.com/appengine/docs/java/overview.html'
  sha1 'f7eda9d0b53d1193ee77a911fba7efd6ef32b181'

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
