require 'formula'

class Libewf < Formula
  homepage 'http://code.google.com/p/libewf/'
  url 'https://googledrive.com/host/0B3fBvzttpiiSMTdoaVExWWNsRjg/libewf-20131230.tar.gz'
  sha1 '2926fc30c211711d9b3091bfc6c21ad896ff2c34'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
