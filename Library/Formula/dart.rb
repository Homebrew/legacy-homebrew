require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/25388/dartsdk-macos-64.zip'
    sha1 '1de7b3933d4c13eb2aac136b2e260ebb3e0af14e'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/25388/dartsdk-macos-32.zip'
    sha1 'cd59aa7bb25f92b67399a2e05e7bebde3c15d684'
  end

  version '25388'

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
