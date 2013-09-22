require 'formula'

class Xctool < Formula
  homepage 'https://github.com/facebook/xctool'
  url 'https://github.com/facebook/xctool/archive/v0.1.12.tar.gz'
  sha1 '283de48744c81941830bcca5e7eb4e312f65ad89'
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
