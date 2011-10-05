require 'formula'

class Fio < Formula
  url 'http://brick.kernel.dk/snaps/fio-1.58.tar.bz2'
  homepage 'http://freshmeat.net/projects/fio/'
  md5 'bc5600997788bce5647576a4976d461d'

  def install
    make_cmd = "make prefix=#{prefix}"
    system "#{make_cmd} && #{make_cmd} install"
  end
end
