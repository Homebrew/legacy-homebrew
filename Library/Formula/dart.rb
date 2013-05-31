require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/23200/dartsdk-macos-64.zip'
    sha1 '8af5bbe273aaa37cea92a3c69f953fff7c81ccd0'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/23200/dartsdk-macos-32.zip'
    sha1 'efed12886482e3350b8707f71efa0883992ec051'
  end

  version '23200'

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
