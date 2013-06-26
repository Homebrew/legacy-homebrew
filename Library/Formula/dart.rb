require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/24275/dartsdk-macos-64.zip'
    sha1 'af75e014b80f27c77ac46cce1ae66fe981490354'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/24275/dartsdk-macos-32.zip'
    sha1 '551c60760205531a1b7a3de62ece82307f1bdad2'
  end

  version '24275'

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
