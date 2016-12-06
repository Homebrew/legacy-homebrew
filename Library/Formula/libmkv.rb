require 'formula'

class Libmkv <Formula
  url 'http://repo.or.cz/w/libmkv.git/snapshot/a80e593de2bcfabd4ad6ca0a5c6b4566e3732557.tar.gz'
  homepage 'http://repo.or.cz/w/libmkv.git'
  version '0.6.4.1'
  md5 '4b4e7e401fe571db500d70551e9e19d2'

  # depends_on 'cmake'

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
