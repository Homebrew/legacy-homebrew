require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/11397/dartsdk-macos-64.zip'
    sha1 '144b487685c8b47d09c40b14689031221e2f4ee8'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/11397/dartsdk-macos-32.zip'
    sha1 '58c7463935dd776e09458ec39ea8a579aad8978f'
  end

  version '11397'

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
    (bin+'dartdoc').write shim_script(libexec+'pkg/dartdoc/dartdoc.dart')
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
