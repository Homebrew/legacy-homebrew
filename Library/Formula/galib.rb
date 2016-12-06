require 'formula'

class Galib < Formula
  homepage 'http://lancet.mit.edu/ga/'
  url 'http://lancet.mit.edu/ga/dist/galib247.tgz'
  version '2.4.7'
  sha1 '3411da19d6b5b67638eddc4ccfab37a287853541'

  def install
    mkdir "#{prefix}/lib"
    system "make DESTDIR=#{prefix} install"
  end
end
