class CrystaxNdk < Formula
  desc "Drop-in replacement for Google's Android NDK"
  homepage "https://www.crystax.net/android/ndk"

  version "10.3.0"

  if MacOS.prefer_64_bit?
    url "https://www.crystax.net/download/crystax-ndk-#{version}-darwin-x86_64.tar.xz"
    sha256 "1c3894aa306fd77e73f299c6b92b7de60465f8a4807d76faf7805595170e938f"
  else
    url "https://www.crystax.net/download/crystax-ndk-#{version}-darwin-x86.tar.xz"
    sha256 "22339c6ef7c4a1e8fb35eb6a948e966c0ae27480a7a0ad6ac3a94f3233199362"
  end

  bottle :unneeded

  depends_on "android-sdk" => :recommended

  conflicts_with "android-ndk",
    :because => "both install `ndk-build`, `ndk-gdb`, `ndk-stack`, `ndk-depends` and `ndk-which` binaries"

  def install
    bin.mkpath

    # Cleanup some files since "brew audit" complains they're linked against system OpenSSL
    # Those files are present there by mistake, and will be removed in next upstream patch version (10.3.1?),
    # so it's safe to remove them here.
    %w[_hashlib.so _ssl.so].each { |file| rm_f Dir.glob("prebuilt/darwin-*/lib/python*/lib-dynload/#{file}") }

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
