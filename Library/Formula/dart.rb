require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/21548/dartsdk-macos-64.zip'
    sha1 '6f19701c5876688ab7968af698652005e48dd96f'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/21548/dartsdk-macos-32.zip'
    sha1 'd1e54616461782354e10fa0decc9c743120ffeed'
  end

  version '21548'

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
