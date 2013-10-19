require 'formula'

class Xctool < Formula
  homepage 'https://github.com/facebook/xctool'
  url 'https://github.com/facebook/xctool/archive/v0.1.13.tar.gz'
  sha1 '60ad514c9b0712177ef89bf576d082d7301a25f0'
  head 'https://github.com/facebook/xctool.git'

  depends_on :xcode
  depends_on :macos => :lion

  def install
    system "./build.sh 'XT_INSTALL_ROOT=#{libexec}'"
    bin.install_symlink "#{libexec}/bin/xctool"
  end

  test do
    system "(#{bin}/xctool -help; true)"
  end
end
