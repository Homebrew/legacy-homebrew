require 'formula'

class Libssh < Formula
  url 'http://www.libssh.org/files/0.5/libssh-0.5.2.tar.gz'
  homepage 'http://www.libssh.org/'
  md5 '38b67c48af7a9204660a3e08f97ceba6'

  depends_on 'cmake' => :build

  def install
    # libssh requires an out of source build
    mkdir 'build'
    cd('build')

    # standard build options from INSTALL
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=Release",
            "-DWITH_LIBZ=OFF",
            ".."]

    system "cmake", *args
    system "make install"
  end
end
