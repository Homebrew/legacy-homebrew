require 'formula'

class LibsvgCairo < Formula
  homepage 'http://cairographics.org/'
  url 'http://cairographics.org/snapshots/libsvg-cairo-0.1.6.tar.gz'
  sha1 'c7bf131b59e8c00a80ce07c6f2f90f25a7c61f81'
  revision 1

  bottle do
    cellar :any
    sha1 "8b6021270a2184ac5c364bbb6e8e102a063e1343" => :mavericks
    sha1 "1d3009933ab4c1c4087dbbc62934523e43aa709d" => :mountain_lion
    sha1 "09e40be714fc8d5d33e1a3cdae17a4106c745f91" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libsvg'
  depends_on 'libpng'
  depends_on 'cairo'

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
