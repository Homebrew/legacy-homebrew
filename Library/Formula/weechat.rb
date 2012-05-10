require 'formula'

class Weechat < Formula
  homepage 'http://www.weechat.org'
  url 'http://www.weechat.org/files/src/weechat-0.3.7.tar.bz2'
  md5 '62bb5002b2ba9e5816dfeededc3fa276'

  depends_on 'cmake' => :build
  depends_on 'gettext'
  depends_on 'gnutls'

  def install
    # Remove all arch flags from the PERL_*FLAGS as we specify them ourselves.
    # This messes up because the system perl is a fat binary with 32, 64 and PPC
    # compiles, but our deps don't have that. Remove at v0.3.8, fixed in HEAD.
    archs = ['-arch ppc', '-arch i386', '-arch x86_64'].join('|')
    inreplace  "src/plugins/scripts/perl/CMakeLists.txt",
      'IF(PERL_FOUND)',
      'IF(PERL_FOUND)' +
      %Q{\n  STRING(REGEX REPLACE "#{archs}" "" PERL_CFLAGS "${PERL_CFLAGS}")} +
      %Q{\n  STRING(REGEX REPLACE "#{archs}" "" PERL_LFLAGS "${PERL_LFLAGS}")}

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-aspell
      --disable-perl
      --disable-static
      --with-debug=0
    ]
    args << '--disable-python' unless python_framework?
    args << '--disable-guile' unless Formula.factory('guile').linked_keg.exist?

    system './configure', *args
    system 'make install'

    # Remove the duplicates to stop error messages when running weechat.
    Dir["#{lib}/weechat/plugins/*"].each do |f|
      rm f if File.symlink? f
    end
  end

  def python_framework?
    # True if Python was compiled as a framework.
    python_prefix = `python-config --prefix`.strip
    File.exist? "#{python_prefix}/Python"
  end

  def caveats; <<-EOS.undent
      Weechat will only build the Python plugin if Python is compiled as
      a framework (system Python or 'brew install --framework python').
    EOS
  end
end
