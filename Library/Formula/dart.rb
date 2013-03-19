require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/20193/dartsdk-macos-64.zip'
    sha1 '8da75b3e6c44c47224a07fa670d2a9fb77326013'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/20193/dartsdk-macos-32.zip'
    sha1 'ebe196d40e4c8757897da8d5c195957bb25af635'
  end

  version '20193'

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
