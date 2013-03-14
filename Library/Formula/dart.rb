require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/19425/dartsdk-macos-64.zip'
    sha1 '7eb284106b7ace99963c30d68f292227ff785363'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/19425/dartsdk-macos-32.zip'
    sha1 'e19497d322603276e46bb489860f1f51a45b04ad'
  end

  version '19425'

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
