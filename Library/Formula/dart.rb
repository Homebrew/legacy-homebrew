require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'
  url 'https://gsdview.appspot.com/dart-editor-archive-integration/7696/dart-macos.zip'
  version '7696'
  md5 '27d9d1a0fba78f2caaea455162f7e166'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      exec "#{target}" "$@"
    EOS
  end

  def install
    libexec.install Dir['*']

    (bin+'dart').write shim_script("#{libexec}/bin/dart")
    (bin+'dart2js').write shim_script("#{libexec}/bin/dart2js")
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
