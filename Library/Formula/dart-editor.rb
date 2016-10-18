require 'formula'

class DartEditor < Formula
  homepage 'http://www.dartlang.org/'
  url 'https://gsdview.appspot.com/dart-editor-archive-integration/8370/dart-editor-macosx.cocoa.x86_64.zip'
  version '8370'
  sha1 '5a44b7c982b5c94c731351ed0bad3525bd78aeb5'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      exec dart "#{target}" "$@"
    EOS
  end

  def install
    unless MacOS.prefer_64_bit?
      onoe 'This is a 64-bit only install'
      exit 1
    end

    if Formula.factory('dart').installed?
      onoe <<-EOS.undent
      You must uninstall the 'dart' formula before continuing.
      This formula includes a superset of the functionality in 'dart'.
      EOS
      exit 1
    end

    prefix.install Dir['*']

    bin.install_symlink Dir[prefix+'dart-sdk/bin/*']

    (bin+'dartdoc').write shim_script(prefix+'dart-sdk/lib/dartdoc/dartdoc.dart')
  end

  def caveats; <<-EOS.undent
    DartEditor.app was installed in:
      #{prefix}

    To symlink into ~/Applications, you can do:
      brew linkapps
    EOS
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
