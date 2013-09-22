require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/27268/dartsdk-macos-64.zip'
    sha1 'bd6106c478d2e9ac5c534a9183369937f7876940'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/27268/dartsdk-macos-32.zip'
    sha1 '6ade0a64690bf5e454f5a0017ad28129f5a03576'
  end

  version '27268'

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
