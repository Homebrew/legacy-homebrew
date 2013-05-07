require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/22416/dartsdk-macos-64.zip'
    sha1 '3b70543450e24c5dad7855ab1db452b72649af69'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/22416/dartsdk-macos-32.zip'
    sha1 '326ad04ef8d09dfc5711e3cb7fb46b7098dad2a2'
  end

  version '22416'

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
