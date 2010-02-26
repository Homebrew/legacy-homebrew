require 'formula'

class Fio <Formula
  url 'http://download.github.com/caius-fio-4ceb30d.tar.gz'
  homepage 'http://freshmeat.net/projects/fio/'
  md5 '1a85a1b492fecd44d0185bd24f01a973'
  version "1.37"

  def install
    make_cmd = "make -f Makefile.mac prefix=#{prefix}"
    system "#{make_cmd} && #{make_cmd} install"
  end
end
