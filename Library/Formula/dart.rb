require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/22223/dartsdk-macos-64.zip'
    sha1 '766856a36ce283951c577ecc102b8b3e2cb0a164'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/22223/dartsdk-macos-32.zip'
    sha1 'fddd7f182e1c099428b53b3cb1fb2efd8b902a51'
  end

  version '22223'

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
