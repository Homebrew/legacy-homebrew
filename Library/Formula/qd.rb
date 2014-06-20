require 'formula'

class Qd < Formula
  homepage 'http://crd.lbl.gov/~dhbailey/mpdist/'
  url 'http://crd.lbl.gov/~dhbailey/mpdist/qd-2.3.14.tar.gz'
  sha1 'bda1048feed8c3a52957e5e63592163aa0a15da4'

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
