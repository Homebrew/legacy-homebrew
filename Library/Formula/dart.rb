require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/25822/dartsdk-macos-64.zip'
    sha1 '5988fc67d0a82f59b802ca9e0aa66419b190bd7a'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/25822/dartsdk-macos-32.zip'
    sha1 '6ac8eee208aef029f4868cc95d7c42973ce60a09'
  end

  version '25822'

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
