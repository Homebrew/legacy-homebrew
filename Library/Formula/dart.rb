require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/31822/sdk/dartsdk-macos-x64-release.zip'
    sha1 'dc43add77fab4519d1a65081822f0623359b52fc'
  else
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/31822/sdk/dartsdk-macos-ia32-release.zip'
    sha1 'b338b539ea826eda3c5990f2ea9c7bd26ac2b411'
  end

  version '31822'

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
