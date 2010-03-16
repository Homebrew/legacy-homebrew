require 'formula'

class Weechat <Formula
  head 'git://git.sv.gnu.org/weechat.git'
  url 'http://www.weechat.org/files/src/weechat-0.3.1.1.tar.bz2'
  homepage 'http://www.weechat.org'
  md5 '25bfb4afef8adc3d52de2c74f0b32550'

  depends_on 'cmake'
  depends_on 'gnutls'

  def install
    #FIXME: Compiling perl module doesn't work
    #NOTE: -DPREFIX has to be specified because weechat devs enjoy being non-standard
    system "cmake", "-DPREFIX=#{prefix}", 
                    "-DDISABLE_PERL=ON",
                    "-DDISABLE_RUBY:BOOL=ON",
                    std_cmake_parameters, "."
    system "make install"
  end
end
