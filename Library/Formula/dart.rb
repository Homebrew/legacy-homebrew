require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/17657/dartsdk-macos-64.zip'
    sha1 '440936b9dd5c48b5fbf769adaf5d092355a342b1'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/17657/dartsdk-macos-32.zip'
    sha1 '6b3ef69af8ab468e612322c454284150588af050'
  end

  version '17657'

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
