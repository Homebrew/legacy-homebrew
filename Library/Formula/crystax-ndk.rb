class CrystaxNdk < Formula
  desc "Drop-in replacement for Google's Android NDK"
  homepage "https://www.crystax.net/android/ndk"

  version "10.3.1"

  if MacOS.prefer_64_bit?
    url "https://www.crystax.net/download/crystax-ndk-#{version}-darwin-x86_64.tar.xz"
    sha256 "6469c37e8fa107db51f9ada26fe3e27fddf3d6c3c51272a783fed36b110550ef"
  else
    url "https://www.crystax.net/download/crystax-ndk-#{version}-darwin-x86.tar.xz"
    sha256 "a59218c0bfc477f0ef2dbd345f21cca4fb1f183b4e154ff7724ea0f6df8a7855"
  end

  bottle :unneeded

  depends_on "android-sdk" => :recommended

  conflicts_with "android-ndk",
    :because => "both install `ndk-build`, `ndk-gdb`, `ndk-stack`, `ndk-depends` and `ndk-which` binaries"

  def install
    bin.mkpath

    prefix.install Dir["*"]

    # Create a dummy script to launch the ndk apps
    ndk_exec = prefix+"ndk-exec.sh"
    ndk_exec.write <<-EOS.undent
      #!/bin/sh
      BASENAME=`basename $0`
      EXEC="#{prefix}/$BASENAME"
      test -e "$EXEC" && exec "$EXEC" "$@"
    EOS
    ndk_exec.chmod 0755
    %w[ndk-build ndk-gdb ndk-stack ndk-depends ndk-which].each { |app| bin.install_symlink ndk_exec => app }
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

  test do
    system "#{bin}/ndk-build", "--version"
    system "#{bin}/ndk-gdb", "--help"
    system "#{bin}/ndk-depends", "--help"
  end
end
