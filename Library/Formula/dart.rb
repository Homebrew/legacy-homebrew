require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'
  url 'https://gsdview.appspot.com/dart-editor-archive-integration/8370/dart-macos.zip'
  version '8370'
  sha1 '3012ee60ef3ecc082a9ce2cb780feffb488540f5'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      exec dart "#{target}" "$@"
    EOS
  end

  def install
    libexec.install Dir['*']

    bin.install_symlink libexec+'bin/dart'
    (bin+'dart2js').write shim_script(libexec+'lib/compiler/implementation/dart2js.dart')
    (bin+'dartdoc').write shim_script(libexec+'lib/dartdoc/dartdoc.dart')
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
