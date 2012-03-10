require 'formula'

class Qd < Formula
  url 'http://crd.lbl.gov/~dhbailey/mpdist/qd-2.3.11.tar.gz'
  homepage 'http://crd.lbl.gov/~dhbailey/mpdist/'
  md5 '4623b3b103897d7fb12c729e8c206969'

  def install
    ENV.fortran

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
