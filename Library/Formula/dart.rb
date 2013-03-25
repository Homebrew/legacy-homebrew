require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/20444/dartsdk-macos-64.zip'
    sha1 'e1676b070532e96fc408c80de1193ed0dea1ff1b'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/20444/dartsdk-macos-32.zip'
    sha1 'df7de6ecdfd758642c8cf551c4bc20a000fce4c2'
  end

  version '20444'

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
