require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/24160/dartsdk-macos-64.zip'
    sha1 'c1d2638336d2bba1fb53063b2d0b65d4589283da'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/24160/dartsdk-macos-32.zip'
    sha1 '89b5053a5bc8acc9baab2ab330573bdabd0c1003'
  end

  version '24160'

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
