require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/15699/dartsdk-macos-64.zip'
    sha1 '7ecee694bf6d454bdce73ab55ce83799447d701e'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/15699/dartsdk-macos-32.zip'
    sha1 '1606706fe74ecc095ef0e25de12a92bbf07c063a'
  end

  version '15699'

  def install
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/dart"
    bin.write_exec_script Dir["#{libexec}/bin/{pub,dart?*}"]
  end

  def test
    mktemp do
      (Pathname.pwd+'sample.dart').write <<-EOS.undent
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
end
