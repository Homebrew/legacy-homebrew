class CrystaxNdk < Formula
  desc "Drop-in replacement for Google's Android NDK"
  homepage "https://www.crystax.net/android/ndk"

  version "10.1.0"

  if MacOS.prefer_64_bit?
    url "https://www.crystax.net/download/crystax-ndk-#{version}-darwin-x86_64.7z"
    sha1 "dc125ae803ede7d4b68ac9d57b30909bfcb1a8d6"
  else
    url "https://www.crystax.net/download/crystax-ndk-#{version}-darwin-x86.7z"
    sha1 "d502f57ea314e5a572387b4492c297f77e68a982"
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
