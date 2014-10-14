require 'formula'

class Dxflib < Formula
  homepage 'http://www.ribbonsoft.com/en/what-is-dxflib'
  url 'http://www.ribbonsoft.com/archives/dxflib/dxflib-2.5.0.0-1.src.tar.gz'
  sha1 'af2e496aaf097e40bdb5d6155ba9b0d176d71729'

  bottle do
    cellar :any
    sha1 "e20ddb14b010c8686963fad454846521b6bc4d2d" => :mavericks
    sha1 "1af6665dba3655d6a47f99ada050ecd585c2ffb1" => :mountain_lion
    sha1 "00b03949f806c24e4d4d3f23023d9ed48e8bfd97" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
