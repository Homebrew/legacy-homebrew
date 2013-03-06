require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/18717/dartsdk-macos-64.zip'
    sha1 '2ef8841fdf21c29f97813863c4c20d3952789e36'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/18717/dartsdk-macos-32.zip'
    sha1 '360e7eea55b8adda3c2635df964d75664eb82ad2'
  end

  version '18717'

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
