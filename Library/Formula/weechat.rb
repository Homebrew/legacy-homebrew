require 'brewkit'

class Weechat <Formula
  @url='http://www.weechat.org/files/src/weechat-0.3.0.tar.bz2'
  @homepage='http://www.weechat.org'
  @md5='c31cfc229e964ff9257cc9c7f9e6c9bc'

  depends_on 'cmake'

  def install
    system "cmake", "-DDISABLE_PERL=ON", std_cmake_parameters, "."
    system "make install"
  end
end
