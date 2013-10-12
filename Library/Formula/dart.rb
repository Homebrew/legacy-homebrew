require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/28108/dartsdk-macos-64.zip'
    sha1 'e31b666d94a792366265b98cb4cd1a64797a8061'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/28108/dartsdk-macos-32.zip'
    sha1 '912f5a3a7bbc34c7ca33d9d7a9ae5b2cb4f59eab'
  end

  version '28108'

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
