require 'formula'

class Xctool < Formula
  homepage 'https://github.com/facebook/xctool'
  url 'https://github.com/facebook/xctool/archive/v0.1.14.tar.gz'
  sha1 '57e610081b781b19ec0c0f2ca81d897b708826f4'
  head 'https://github.com/facebook/xctool.git'

  depends_on :xcode
  depends_on :macos => :lion

  # Fix build with Xcode 5.1; fixed upstream, will be in next release
  patch :p1 do
    url "https://github.com/facebook/xctool/commit/dfaee8590006a384f53d25bcf4876e0ba28509f7.patch"
    sha1 "00eff52c29d272c5ee091fbc1e32734817eafdfb"
  end

  def install
    system "./scripts/build.sh", "XT_INSTALL_ROOT=#{libexec}"
    bin.install_symlink "#{libexec}/bin/xctool"
  end

  test do
    system "(#{bin}/xctool -help; true)"
  end
end
