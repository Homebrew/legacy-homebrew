require 'formula'

class Fio < Formula
  url 'http://brick.kernel.dk/snaps/fio-1.37.tar.bz2'
  homepage 'http://freshmeat.net/projects/fio/'
  md5 'a6b64ffef21c0c9e3dc3c36e87f988a5'

  def install
    make_cmd = "make -f Makefile.mac prefix=#{prefix}"
    system "#{make_cmd} && #{make_cmd} install"
  end
end
