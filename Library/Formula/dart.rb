require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/22611/dartsdk-macos-64.zip'
    sha1 'd7a69c052149d99a5cc22d7d77d6fe7efc609b6d'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/22611/dartsdk-macos-32.zip'
    sha1 '085dbf23157f574f6fc538e616ecd4e71119a685'
  end

  version '22611'

  def install
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/dart"
    bin.write_exec_script Dir["#{libexec}/bin/{pub,dart?*}"]
  end

  test do
    (testpath/'sample.dart').write <<-EOS.undent
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
