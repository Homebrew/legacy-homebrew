require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/20602/dartsdk-macos-64.zip'
    sha1 'd5ba351fe5f60f0e2eb9da589a4f2f902cfc9b68'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/20602/dartsdk-macos-32.zip'
    sha1 '703b2fb61a7df03e898eb1fb332b3d004b7b9a34'
  end

  version '20602'

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
