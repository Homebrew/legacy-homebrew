require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/22879/dartsdk-macos-64.zip'
    sha1 '5022678a3bb06216f924b47ed8503174e6637c5e'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/22879/dartsdk-macos-32.zip'
    sha1 'c75e9a4b977275fe35e036e6be1b14a68b80b431'
  end

  version '22879'

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
