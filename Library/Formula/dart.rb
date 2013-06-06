require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/23552/dartsdk-macos-64.zip'
    sha1 '45cdf025db69a86b7448c57c2031f304439e0949'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/23552/dartsdk-macos-32.zip'
    sha1 '0ba113ca9a1c95e066752b856b9015d4b9398027'
  end

  version '23552'

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
