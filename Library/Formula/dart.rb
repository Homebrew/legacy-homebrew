require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/30798/sdk/dartsdk-macos-x64-release.zip'
    sha1 '0e2910b34b42d4e78d9e424e722196f67ca373ba'
  else
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/30798/sdk/dartsdk-macos-ia32-release.zip'
    sha1 'ec817a854c228c876de9f987ce9e48ec7834b65b'
  end

  version '30798'

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
