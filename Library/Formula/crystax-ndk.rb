class CrystaxNdk < Formula
  desc "Drop-in replacement for Google's Android NDK"
  homepage "https://www.crystax.net/android/ndk"

  version "10.2.0"

  if MacOS.prefer_64_bit?
    url "https://www.crystax.net/download/crystax-ndk-#{version}-darwin-x86_64.7z"
    sha1 "c75b07a79f7f40d947f70fd36dbcdc08fbee686e"
  else
    url "https://www.crystax.net/download/crystax-ndk-#{version}-darwin-x86.7z"
    sha1 "d199ce7d0c325e8ab71b04a9d41bf925ac7e03a1"
  end

  depends_on "android-sdk" => :recommended

  def install
    bin.mkpath

    if MacOS.prefer_64_bit?
      arch = :x86_64
    else
      arch = :x86
    end

    system "7z", "x", "crystax-ndk-#{version}-darwin-#{arch}.7z"

    prefix.install Dir["crystax-ndk-#{version}/*"]

    # Create a dummy script to launch the ndk apps
    ndk_exec = prefix+"ndk-exec.sh"
    ndk_exec.write <<-EOS.undent
      #!/bin/sh
      BASENAME=`basename $0`
      EXEC="#{prefix}/$BASENAME"
      test -f "$EXEC" && exec "$EXEC" "$@"
    EOS
    ndk_exec.chmod 0755
    %w[ndk-build ndk-gdb ndk-stack].each { |app| bin.install_symlink ndk_exec => app }
  end

  test do
    system "#{bin}/ndk-build", "--version"
    system "#{bin}/ndk-gdb", "--help"
  end

  def caveats; <<-EOS.undent
    We agreed to the CrystaX NDK License Agreement for you by downloading the NDK.
    If this is unacceptable you should uninstall.

    License information at:
    https://www.crystax.net/android/ndk#license

    For more documentation on CrystaX NDK, please check:
    #{homepage}
    EOS
  end
end
