require 'formula'

class Qd < Formula
  url 'http://crd.lbl.gov/~dhbailey/mpdist/qd-2.3.13.tar.gz'
  homepage 'http://crd.lbl.gov/~dhbailey/mpdist/'
  md5 '1c901295624d91df0114614f2ccf914f'

  def install
    ENV.fortran

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
