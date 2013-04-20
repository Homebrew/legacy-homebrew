require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/21658/dartsdk-macos-64.zip'
    sha1 '4bae23519e9d2f16d6b296b87053343f16d3e076'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/21658/dartsdk-macos-32.zip'
    sha1 'c4828db4dc18f388a1b9b928f701a093075850a6'
  end

  version '21658'

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
