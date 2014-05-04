require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/37972/sdk/dartsdk-macos-x64-release.zip'
    sha1 'c775e8a2eb2f4e68961d2b96789bc35120515403'
  else
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/37972/sdk/dartsdk-macos-ia32-release.zip'
    sha1 'e9e469804139ed0b22b3ba318cb7b4ae1000e20c'
  end

  version '1.5.3'

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

    assert_equal "test message\n", shell_output("#{bin}/dart sample.dart")
  end
end
