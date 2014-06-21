require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/37348/sdk/dartsdk-macos-x64-release.zip'
    sha1 '5de0801c3140929b9e32d837a7ca0ac4b34422fa'
  else
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/37348/sdk/dartsdk-macos-ia32-release.zip'
    sha1 'f0a2603e32d4fbc3f5553875f0044705d693cca8'
  end

  version '1.4.3'

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
