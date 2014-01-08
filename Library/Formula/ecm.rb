require 'formula'

class Ecm < Formula
  homepage 'http://www.neillcorlett.com/ecm/'
  url 'http://critical.ch/distfiles/ecm-1.0.tar.gz'
  sha1 'bfda1031e22b23e3c4d1a713f675de2a9778a421'

  def install
    system "#{ENV.cc} -o ecm ecm.c"
    system "#{ENV.cc} -o unecm unecm.c"
    bin.install 'ecm', 'unecm'
  end
end
