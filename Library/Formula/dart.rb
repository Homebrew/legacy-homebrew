require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/10994/dartsdk-macos-64.zip'
    sha1 '39af10bc1d2c9d33d7b6f485ce39db75e552d789'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/10994/dartsdk-macos-32.zip'
    sha1 '168bfac62bfd1f717d7b51568d5a7a0f726c493b'
  end

  version '10994'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      exec dart "#{target}" "$@"
    EOS
  end

  def install
    libexec.install Dir['*']

    bin.install_symlink libexec+'bin/dart'
    (bin+'dart2js').write shim_script(libexec+'lib/dart2js/lib/compiler/implementation/dart2js.dart')
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
