require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'
  url 'https://gsdview.appspot.com/dart-editor-archive-integration/9474/dart-macos.zip'
  version '9474'
  sha1 'be58f1fcb223bf1f109d2b7a3c35d75072bf3fe1'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      #{target} "$@"
    EOS
  end

  def dart_script target
    <<-EOS.undent
      #!/bin/bash
      exec dart "#{target}" "$@"
    EOS
  end

  def install
    libexec.install Dir['*']

    bin.install_symlink libexec+'bin/dart'
    (bin+'dart_analyzer').write shim_script(libexec+'bin/dart_analyzer')
    (bin+'dart2js').write shim_script(libexec+'bin/dart2js')
    (bin+'pub').write shim_script(libexec+'bin/pub')
    (bin+'dartdoc').write dart_script(libexec+'lib/dartdoc/dartdoc.dart')
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
