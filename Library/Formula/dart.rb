require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/38663/sdk/dartsdk-macos-x64-release.zip'
    sha1 'fc214070863861e444b0a9619dd92a93c0932bc9'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/38663/sdk/dartsdk-macos-ia32-release.zip'
    sha1 'd6d2ba9950f3625d15c39814c183364dcd46b945'
  end

  version '1.5.8'

  devel do
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/38831/sdk/dartsdk-macos-x64-release.zip'
      sha1 'ed2bc149a6bb5c8b48b8d818269c0be392dc8361'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/38831/sdk/dartsdk-macos-ia32-release.zip'
      sha1 'fccba1c2289faaa83b596f7335e107c7b581e2fe'
    end

    version '1.6.0-dev.7.0'
  end

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
