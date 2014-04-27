require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/35121/sdk/dartsdk-macos-x64-release.zip'
    sha1 '5f4daec23a4ce3f58ecdc8b0c77c6448c3562fc5'
  else
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/35121/sdk/dartsdk-macos-ia32-release.zip'
    sha1 '8ec49b7acc2ea959c96b76f5d7522825b1511e19'
  end

  version '1.3.3'

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
