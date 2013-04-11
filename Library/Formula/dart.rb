require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/21094/dartsdk-macos-64.zip'
    sha1 '4125a5792bb4a9eb522d11dc976bad21be4abc95'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/21094/dartsdk-macos-32.zip'
    sha1 '512991bda44252d5825ecab088d9f17467dea716'
  end

  version '21094'

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
