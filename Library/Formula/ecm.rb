require 'formula'

class Ecm < Formula
  homepage 'http://www.neillcorlett.com/ecm/'
  url 'http://critical.ch/distfiles/ecm-1.0.tar.gz'
  md5 '16302c139137434c8793cc7938cc7afe'

  def install
    system "#{ENV.cc} -o ecm ecm.c"
    system "#{ENV.cc} -o unecm unecm.c"
    bin.install 'ecm', 'unecm'
  end
end
