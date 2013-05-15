require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/22659/dartsdk-macos-64.zip'
    sha1 'd58ed4aa09aba8d45b499a28f2df27c1edd2254a'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/22659/dartsdk-macos-32.zip'
    sha1 '09bfd658d0159ab942c0eed0ee2d9ded1ef07b94'
  end

  version '22659'

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
