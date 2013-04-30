require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/22072/dartsdk-macos-64.zip'
    sha1 'a4c2ed5b82410ee72197d36f1be41e0c967932b4'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/22072/dartsdk-macos-32.zip'
    sha1 '6f9afbc6ab0c99e51df884f707d24e26fdb8c208'
  end

  version '22072'

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
