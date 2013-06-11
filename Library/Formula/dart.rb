require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/23799/dartsdk-macos-64.zip'
    sha1 '50bcca5ad9fcd6958fa33702199fbced574a76fe'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/23799/dartsdk-macos-32.zip'
    sha1 'c3f6e89a263d947eb5451e58cf70ef5c1dc78f88'
  end

  version '23799'

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

    assert_equal "test\nmessage\n", `#{bin}/dart sample.dart test message`
  end
end
