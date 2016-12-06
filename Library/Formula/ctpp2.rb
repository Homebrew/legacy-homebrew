require 'formula'


class Ctpp2 < Formula
  url 'http://ctpp.havoc.ru/download/ctpp2-2.8.tar.gz'
  homepage 'http://ctpp.havoc.ru'
  md5 'f9474c6dae89b7c514a997d505c32e76'

  depends_on 'cmake' => :build

  def install
    system "cmake #{std_cmake_parameters} ."
  end

end

__END__
