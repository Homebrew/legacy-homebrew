require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/30107/sdk/dartsdk-macos-x64-release.zip'
    sha1 'bb1e6c1f4f75f37bbca767127dba95d3a051e72d'
  else
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/30107/sdk/dartsdk-macos-ia32-release.zip'
    sha1 '772041f056154a740b8608a8723e8e14a328be6f'
  end

  version '30107'

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
