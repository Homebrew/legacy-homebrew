require 'formula'

class Weechat <Formula
  head 'git://git.sv.gnu.org/weechat.git'
  url 'http://www.weechat.org/files/src/weechat-0.3.3.tar.bz2'
  homepage 'http://www.weechat.org'
  md5 '01648f8717ab1ea5233f9818d45a7c24'

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
