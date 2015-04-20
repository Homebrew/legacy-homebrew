require 'formula'

class Dialog < Formula
  homepage 'http://invisible-island.net/dialog/'
  url 'ftp://invisible-island.net/dialog/dialog-1.2-20130928.tgz'
  sha1 '204d852856754817f5590f60ffaa1c07a8ed35ca'

  bottle do
    cellar :any
    sha1 "ed04a10d2cbe61af48b5a0c5232f9612efb2b6a6" => :yosemite
    sha1 "bd04f2988844a9be9aed5796aff53365ff635a76" => :mavericks
    sha1 "4ef77c2932c8a75f79170a98e9434201744e0193" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
