require 'formula'

class Roundup <Formula
  url 'http://pypi.python.org/packages/source/r/roundup/roundup-1.4.16.tar.gz#md5=4ef7432c612e57429d34278572d40934'
  homepage ''
  md5 ''
  version '1.4.16'

  # depends_on 'cmake'

  def install
    system "python", "setup.py", "install",
                                 "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    # system "make install"
  end
end
