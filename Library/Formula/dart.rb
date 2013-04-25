require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/21823/dartsdk-macos-64.zip'
    sha1 '6a901c5ba2e18696cab80d02f071656dcb5b2fc1'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/21823/dartsdk-macos-32.zip'
    sha1 '200c7db0cf092518ab6d7a61dcc9d724ce2e10ae'
  end

  version '21823'

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
