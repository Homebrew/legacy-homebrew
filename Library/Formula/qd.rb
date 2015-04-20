require 'formula'

class Qd < Formula
  homepage 'http://crd.lbl.gov/~dhbailey/mpdist/'
  url 'http://crd.lbl.gov/~dhbailey/mpdist/qd-2.3.14.tar.gz'
  sha1 'bda1048feed8c3a52957e5e63592163aa0a15da4'
  bottle do
    cellar :any
    sha1 "0b419d709130b3a5ca2e2bb6d770113c3ea16b9c" => :yosemite
    sha1 "0cedfdd4df839ff311c7cb9add9ab242fa31e66f" => :mavericks
    sha1 "a8ad0c971cf98952cf8f56c714b87ebaf4db7828" => :mountain_lion
  end

  revision 1

  depends_on :fortran => :recommended

  def install
    args = ["--disable-dependency-tracking", "--enable-shared", "--prefix=#{prefix}"]
    args << "--enable-fortran=no" if build.without? :fortran
    system "./configure", *args
    system "make"
    system "make check"
    system "make install"
  end
end
