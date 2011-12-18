require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'
  url 'http://commondatastorage.googleapis.com/dart-dump-render-tree/sdk/dart-macos-2559.zip'
  md5 '0569646b92aa059f1ca024f9504b32eb'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      exec "#{target}" "$@"
    EOS
  end

  def install
    libexec.install Dir['*']

    (bin+'dart').write shim_script("#{libexec}/bin/dart")
    (bin+'frogc').write shim_script("#{libexec}/bin/frogc")
  end

  def test
    system "#{bin}/dart"
  end
end
