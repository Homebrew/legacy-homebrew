require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/24898/dartsdk-macos-64.zip'
    sha1 '5d076bdbaf25849ac0951d1c9a6345c83022368f'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/24898/dartsdk-macos-32.zip'
    sha1 '2894e8388b8e8ab85b8a59aae4311d20d4829887'
  end

  version '24898'

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
