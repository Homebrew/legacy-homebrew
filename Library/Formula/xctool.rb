require 'formula'

class Xctool < Formula
  homepage 'https://github.com/facebook/xctool'
  url 'https://github.com/facebook/xctool/archive/v0.1.11.tar.gz'
  sha1 '3187db03ac04f8d3a763b83d6e950d0a7571fb6d'
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
