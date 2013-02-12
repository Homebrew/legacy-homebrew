require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/18115/dartsdk-macos-64.zip'
    sha1 '3cd57696a33e34cc2f33e1bb529c4bd4b59ebe6c'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/18115/dartsdk-macos-32.zip'
    sha1 '01c7f8022681e65814ed5e7751ad1a4dba686a04'
  end

  version '18115'

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
