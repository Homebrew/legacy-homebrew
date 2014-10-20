require 'formula'

class Libdmtx < Formula
  homepage 'http://www.libdmtx.org'
  url 'https://downloads.sourceforge.net/project/libdmtx/libdmtx/0.7.4/libdmtx-0.7.4.tar.bz2'
  sha1 '016282df12c4046338b9ff73f3d8b39f023bae16'

  bottle do
    cellar :any
    revision 1
    sha1 "43462753a32c217d3c2c9e022cd8fe0b7ad377d2" => :yosemite
    sha1 "c5847ec7293fe289749c9628ec5635ec57e2ce93" => :mavericks
    sha1 "4abe90743ec104a81eb13348cd7d4dfccb78f33c" => :mountain_lion
  end

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
