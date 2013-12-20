require 'formula'

class Xctool < Formula
  homepage 'https://github.com/facebook/xctool'
  url 'https://github.com/facebook/xctool/archive/v0.1.14.tar.gz'
  sha1 '57e610081b781b19ec0c0f2ca81d897b708826f4'
  head 'https://github.com/facebook/xctool.git'

  depends_on :xcode
  depends_on :macos => :lion

  def install
    system "./scripts/build.sh 'XT_INSTALL_ROOT=#{libexec}'"
    bin.install_symlink "#{libexec}/bin/xctool"
  end

  test do
    system "(#{bin}/xctool -help; true)"
  end
end
