require 'formula'

class Weechat <Formula
  head 'git://git.sv.gnu.org/weechat.git'
  url 'http://www.weechat.org/files/src/weechat-0.3.3.tar.bz2'
  homepage 'http://www.weechat.org'
  md5 '01648f8717ab1ea5233f9818d45a7c24'

  depends_on 'cmake' => :build
  depends_on 'gnutls'

  def install

    # Remove all arch flags from the PERL_*FLAGS as we specify them ourselves.
    # This messes up because the system perl is a fat binary with 32,64 and PPC
    # compiles, but our deps don't have that.
    archs = ['-arch ppc', '-arch i386', '-arch x86_64']
    inreplace  "src/plugins/scripts/perl/CMakeLists.txt",
      'IF(PERL_FOUND)',
      'IF(PERL_FOUND)' +
      %Q{\n  STRING(REGEX REPLACE "#{archs.join '|'}" "" PERL_CFLAGS "${PERL_CFLAGS}")} +
      %Q{\n  STRING(REGEX REPLACE "#{archs.join '|'}" "" PERL_LFLAGS "${PERL_LFLAGS}")}

    #FIXME: Compiling perl module doesn't work
    #NOTE: -DPREFIX has to be specified because weechat devs enjoy being non-standard
    system "cmake", "-DPREFIX=#{prefix}",
                    "-DDISABLE_RUBY:BOOL=ON",
                    std_cmake_parameters, "."
    system "make install"
  end
end
