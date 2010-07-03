require 'formula'

class AppEngineJavaSdk <Formula
  url 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.3.5.zip'
  homepage 'http://code.google.com/appengine/docs/java/overview.html'
  sha1 '9629b22bdf35975fa2c4f8d6704c66cfbd2fff7d'

  def shim_script target
    <<-EOS.undent
      #!/usr/bin/env bash
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
