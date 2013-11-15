require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/30188/sdk/dartsdk-macos-x64-release.zip'
    sha1 '1488243e69a12194625a8ef483cfd3614f7e14f0'
  else
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/30188/sdk/dartsdk-macos-ia32-release.zip'
    sha1 '59b7119ad7db5823c5959c57bd0943a7428430db'
  end

  version '30188'

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
