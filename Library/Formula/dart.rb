require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/28355/dartsdk-macos-64.zip'
    sha1 '577d4bab25dc7fd98318e42c75c6a15b5306aa47'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/28355/dartsdk-macos-32.zip'
    sha1 '10e5abc3b538c94ff145e7cd7d7de3689a7ba4d3'
  end

  version '28355'

  def install
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/dart"
    bin.write_exec_script Dir["#{libexec}/bin/{pub,dart?*}"]
  end

  test do
    (testpath/'sample.dart').write <<-EOS.undent
      import 'dart:io';
      void main() {
        Options opts = new Options();
        for (String arg in opts.arguments) {
          print(arg);
        }
      }
    EOS

    assert_equal "test\nmessage\n", `#{bin}/dart sample.dart test message`
  end
end
