require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/36345/sdk/dartsdk-macos-x64-release.zip'
    sha1 '8ed175ea11d41298f5fcbea569f16d349fa798f0'
  else
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/36345/sdk/dartsdk-macos-ia32-release.zip'
    sha1 '4562f8ca166b50b2be882130a6a666de1b58f887'
  end

  version '1.4.0'

  def install
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/dart"
    bin.write_exec_script Dir["#{libexec}/bin/{pub,dart?*}"]
  end

  def caveats; <<-EOS.undent
    To use with IntelliJ, set the Dart home to:
      #{opt_libexec}
    EOS
  end

  test do
    (testpath/'sample.dart').write <<-EOS.undent
      void main() {
        print(r"test message");
      }
    EOS

    assert_equal "test message\n", `#{bin}/dart sample.dart`
  end
end
