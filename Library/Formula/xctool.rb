require 'formula'

class Xctool < Formula
  homepage 'https://github.com/facebook/xctool'
  url 'https://github.com/facebook/xctool/archive/v0.1.5.tar.gz'
  sha1 '6b7442963a069b28c823c727756c747def29f773'
  head 'https://github.com/facebook/xctool.git'

  depends_on :xcode

  def install
    system './build.sh'
    # Install all files together in libexec so the binary can find the dylibs.
    libexec.install 'build/Products/Release/xctool'
    libexec.install Dir['build/Products/Release/*.dylib']
    libexec.install 'build/Products/Release/mobile-installation-helper.app'
    # Link the binary into bin
    bin.install_symlink libexec/'xctool'
  end

  test do
    system "(#{bin}/xctool -help; true)"
  end
end
