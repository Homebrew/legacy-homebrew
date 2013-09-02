require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/26639/dartsdk-macos-64.zip'
    sha1 '05ea242a3699cae6495166286395969a1498d526'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/26639/dartsdk-macos-32.zip'
    sha1 '53388f18e4a01e287bf097ad51a764e4f907229a'
  end

  version '26639'

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
