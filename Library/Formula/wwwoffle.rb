require 'formula'

class Wwwoffle <Formula
  url 'http://www.gedanken.demon.co.uk/download-wwwoffle/wwwoffle-2.9f.tgz'
  homepage 'http://www.gedanken.demon.co.uk/wwwoffle/'
  md5 'a5f04c190a2f27f28cfc744c478e6aaa'
  version '2.9f'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
