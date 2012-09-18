require 'formula'

class Qd < Formula
  url 'http://crd.lbl.gov/~dhbailey/mpdist/qd-2.3.13.tar.gz'
  homepage 'http://crd.lbl.gov/~dhbailey/mpdist/'
  sha1 'f46d63eb5e21172a6f66884b4ddbb352b327a9ca'

  def install
    ENV.fortran

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
