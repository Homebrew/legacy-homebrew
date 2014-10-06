require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/39553/sdk/dartsdk-macos-x64-release.zip'
    sha256 '98fba491b86e70d7fc44ed69977b365b96f9d7d79a3a95a89553df9aafaf7f81'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/39553/sdk/dartsdk-macos-ia32-release.zip'
    sha256 '2ad33e57098fb567c6b627d149899ad301de88f03edc92c74611956642eca382'
  end

  version '1.6.0'

  devel do
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/39537/sdk/dartsdk-macos-x64-release.zip'
      sha256 '5042082e881e3d074728045e01e6adc4a351e76945fdec0f3a9164e76475308b'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/39537/sdk/dartsdk-macos-ia32-release.zip'
      sha256 '87b98b2e0be44930ad2aaa09c5042aa9b15618e37c6e7df1739f6a786b464d51'
    end

    version '1.6.0-dev.9.7'
  end

  def install
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/dart"
    bin.write_exec_script Dir["#{libexec}/bin/{pub,docgen,dart?*}"]
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
