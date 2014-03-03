require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/32314/sdk/dartsdk-macos-x64-release.zip'
    sha1 'c5becd88d9d2348193b954e3d9077d86f30b2536'
  else
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/32314/sdk/dartsdk-macos-ia32-release.zip'
    sha1 '3070a2aa852ed1769763568ef91736235ac5bd2a'
  end

  version '1.1.3'

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
      void main() {
        print(r"test message");
      }
    EOS

    assert_equal "test message\n", `#{bin}/dart sample.dart`
  end
end
