require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/29341/dartsdk-macos-64.zip'
    sha1 '4deec77f9b6a3cd495115384d2e5806baaca0516'
  else
    url 'https://gsdview.appspot.com/dart-editor-archive-integration/29341/dartsdk-macos-32.zip'
    sha1 'fe0fa1e27ecff186a2a8616f6eecbf10649776b7'
  end

  version '29341'

  def install
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/dart"
    bin.write_exec_script Dir["#{libexec}/bin/{pub,dart?*}"]
  end

  def caveats; <<-EOS.undent
    To use with IntelliJ, set the Dart home to:
      #{opt_prefix}/libexec
    EOS
  end

  test do
    (testpath/'sample.dart').write <<-EOS.undent
      import 'dart:io';
      void main() {
        Options opts = new Options();
        for (String arg in opts.arguments) {
          print(arg);
        }
      }
    EOS

    assert_equal "test\nmessage\n", `#{bin}/dart sample.dart test message`
  end
end
