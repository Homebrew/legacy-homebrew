require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/13679/dartsdk-macos-64.zip'
    sha1 'b6f4902cbc48e59799980b2830108ccb2fe8d2b7'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/13679/dartsdk-macos-32.zip'
    sha1 'aa92ba954aa730e58216520f9ddd7c0489d7ae06'
  end

  version '13679'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      exec dart "#{target}" "$@"
    EOS
  end

  def install
    libexec.install Dir['*']

    bin.install_symlink libexec+'bin/dart'
    (bin+'dart2js').write shim_script(libexec+'pkg/compiler/implementation/dart2js.dart')
    (bin+'dartdoc').write shim_script(libexec+'pkg/dartdoc/bin/dartdoc.dart')
    (bin+'pub').write shim_script(libexec+'util/pub/pub.dart')
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
