require 'formula'

class Dart < Formula
  url 'http://commondatastorage.googleapis.com/dart-dump-render-tree/sdk/dart-macos-2559.zip'
  homepage 'http://www.dartlang.org/'
  md5 '0569646b92aa059f1ca024f9504b32eb'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      #{libexec}/#{target} $*
    EOS
  end

  def install
    ENV.no_optimization

    libexec.install Dir['*']

    (bin+'dart').write shim_script('bin/dart')
    (bin+'frogc').write shim_script('bin/frogc')
  end

  def test
    system "#{bin}/dart"
  end
end
