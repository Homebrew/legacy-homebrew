require 'formula'

class Weechat < Formula
  homepage 'http://www.weechat.org'
  url 'http://www.weechat.org/files/src/weechat-0.3.7.tar.bz2'
  md5 '62bb5002b2ba9e5816dfeededc3fa276'

  head 'git://git.sv.gnu.org/weechat.git'

  depends_on 'cmake' => :build
  depends_on 'gnutls'

  def options
    [
      ["--enable-ruby", "Enable Ruby module"],
      ["--enable-perl", "Enable Perl module"],
      ["--enable-python", "Enable Python module"],
    ]
  end

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

    args = []

    if ARGV.include? "--enable-ruby"
      args << "-DENABLE_RUBY=ON"
    else
      args << "-DENABLE_RUBY=OFF"
    end

    if ARGV.include? "--enable-perl"
      args << "-DENABLE_PERL=ON"
    else
      args << "-DENABLE_PERL=OFF"
    end

    if ARGV.include? "--enable-python"
      args << "-DENABLE_PYTHON=ON"
    else
      args << "-DENABLE_PYTHON=OFF"
    end

    # -DPREFIX has to be specified because weechat devs enjoy being non-standard
    system "cmake", "-DPREFIX=#{prefix}",
                    args.join(" "),
                    std_cmake_parameters,
                    "."
    system "make install"
  end
end
