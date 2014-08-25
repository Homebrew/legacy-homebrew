require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/38663/sdk/dartsdk-macos-x64-release.zip'
    sha256 'ee1f349007e270c3b9b0e217c16fc41cf02c130b662d645185098efc92a76a93'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/38663/sdk/dartsdk-macos-ia32-release.zip'
    sha256 '1999d80f14c4c89c2246670f84fb4cf23faa7d0ed28dc136bc7d57c21ef95e86'
  end

  version '1.5.8'

  devel do
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/39401/sdk/dartsdk-macos-x64-release.zip'
      sha256 '93a9385f81973feef779e4282c0a37c657691c39b8c91386f11364ad4314f68f'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/39401/sdk/dartsdk-macos-ia32-release.zip'
      sha256 '4d0bcc08353af4a790dd12a0dce5cceba2a9034ae50bc205f52f60b79ecc7536'
    end

    version '1.6.0-dev.9.5'
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
