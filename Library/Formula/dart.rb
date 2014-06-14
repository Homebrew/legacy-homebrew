require 'formula'

class Dart < Formula
  homepage 'http://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/36647/sdk/dartsdk-macos-x64-release.zip'
    sha1 '028edb73863e42dcfce39df31728bceffd347510'
  else
    url 'http://storage.googleapis.com/dart-archive/channels/stable/release/36647/sdk/dartsdk-macos-ia32-release.zip'
    sha1 '388027b201ce22b66faa9f48e22bfd6ed01c5ff3'
  end

  version '1.4.2'

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
