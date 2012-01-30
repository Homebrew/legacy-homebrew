require 'formula'

class Weechat < Formula
  url 'http://www.weechat.org/files/src/weechat-0.3.6.tar.bz2'
  homepage 'http://www.weechat.org'
  md5 'db2392b8e31738f79f0898f77eda8daa'

  head 'git://git.sv.gnu.org/weechat.git'

  depends_on 'cmake' => :build
  depends_on 'gnutls'

  def install
    # Remove all arch flags from the PERL_*FLAGS as we specify them ourselves.
    # This messes up because the system perl is a fat binary with 32, 64 and PPC
    # compiles, but our deps don't have that.
    archs = ['-arch ppc', '-arch i386', '-arch x86_64'].join('|')

    inreplace  "src/plugins/scripts/perl/CMakeLists.txt",
      'IF(PERL_FOUND)',
      'IF(PERL_FOUND)' +
      %Q{\n  STRING(REGEX REPLACE "#{archs}" "" PERL_CFLAGS "${PERL_CFLAGS}")} +
      %Q{\n  STRING(REGEX REPLACE "#{archs}" "" PERL_LFLAGS "${PERL_LFLAGS}")}

    # -DPREFIX has to be specified because weechat devs enjoy being non-standard
    # Compiling langauge module doesn't work. Feel free to add options to enable these.
    system "cmake", "-DPREFIX=#{prefix}",
                    "-DENABLE_RUBY=OFF",
                    "-DENABLE_PERL=OFF",
                    "-DENABLE_PYTHON=OFF",
                    std_cmake_parameters, "."
    system "make install"
  end
end
