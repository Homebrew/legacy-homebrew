require 'formula'

class FuseZip < Formula
  homepage 'https://code.google.com/p/fuse-zip/'
  url 'https://fuse-zip.googlecode.com/files/fuse-zip-0.4.0.tar.gz'
  sha1 '09ee8c6f9d045436309e126d891510540c3d68fa'
  head 'https://code.google.com/p/fuse-zip/', :using => :hg

  depends_on 'pkg-config' => :build
  depends_on 'osxfuse'
  depends_on 'libzip'

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    system bin/"fuse-zip", "--help"
  end
end
