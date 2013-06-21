require 'formula'

class Xctool < Formula
  homepage 'https://github.com/facebook/xctool'
  url 'https://github.com/facebook/xctool/archive/v0.1.4.tar.gz'
  sha1 'da0243f65ae825b920e60d850c42230aa1a5afe1'
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
