require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/37644/sdk/dartsdk-macos-x64-release.zip'
    sha1 'cce144228fae95b3100f358ebfef41b71b4a8c4e'
  else
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/37644/sdk/dartsdk-macos-ia32-release.zip'
    sha1 '09e65b12709c0bc028b89678eb15ca8b26ada8ad'
  end

  version '1.5.1'

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
