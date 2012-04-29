require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'
  url 'https://gsdview.appspot.com/dart-editor-archive-integration/6943/dart-macos.zip'
  version '6943'
  md5 '489fa4e956745066c8cbbaed6e2cd76c'

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
    mktemp do
      (Pathname.pwd+'sample.dart').write <<-EOS.undent
      void main() {
        Options opts = new Options();
        for (String arg in opts.arguments) {
          print(arg);
        }
      }
      EOS

      `#{bin}/dart sample.dart test message` == "test\nmessage\n"
    end
  end
end
