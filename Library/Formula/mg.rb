require 'formula'

class Mg < Formula
  url 'http://pintday.org/hack/mg/mg-p-080818.tgz'
  homepage 'http://pintday.org/hack/mg/'
  md5 '5cdd46b226586306bde2dd5d47920d66'

  def install
    system "make PREFIX=#{prefix}"
    bin.mkpath # otherwise install copies 'mg' to 'bin'
    system "make install PREFIX=#{prefix}"
  end
end
