require 'formula'

class Weechat < Formula
  homepage 'http://www.weechat.org'
  url 'http://www.weechat.org/files/src/weechat-0.3.7.tar.bz2'
  md5 '62bb5002b2ba9e5816dfeededc3fa276'

  depends_on 'cmake' => :build
  depends_on 'gettext'
  depends_on 'gnutls'
  depends_on 'guile' if ARGV.include? '--guile'

  # Patch fixes the perl bindings to not segfault on exit.  Remove at 0.3.8.
  # Adapted from the weechat patch which would not apply cleanly.
  # http://git.savannah.gnu.org/gitweb/?p=weechat.git;a=patch;h=2b26348965941c961f1ad73cfc7c6605be5abf3e
  def patches
    DATA
  end

  def options
    [
      ['--perl', 'Build the perl module.'],
      ['--ruby', 'Build the ruby module.'],
      ['--guile', 'Build the guile module.'],
      ['--python', 'Build the python module (requires framework Python).']
    ]
  end

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
      --disable-static
      --with-debug=0
    ]
    args << '--disable-perl' unless ARGV.include? '--perl'
    args << '--disable-ruby' unless ARGV.include? '--ruby'
    args << '--disable-python' unless python_framework? and ARGV.include? '--python'
    args << '--disable-guile' unless Formula.factory('guile').linked_keg.exist? \
                              and ARGV.include? '--guile'

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

__END__
--- a/src/plugins/scripts/perl/weechat-perl.c	2012-02-20 05:07:35.000000000 -0800
+++ b/src/plugins/scripts/perl/weechat-perl.c	2012-05-23 11:00:10.000000000 -0700
@@ -1016,7 +1016,7 @@
     }
 #endif
 
-#if defined(PERL_SYS_TERM) && !defined(__FreeBSD__) && !defined(WIN32) && !defined(__CYGWIN__)
+#if defined(PERL_SYS_TERM) && !defined(__FreeBSD__) && !defined(WIN32) && !defined(__CYGWIN__) && !(defined(__APPLE__) && defined(__MACH__))
     /*
      * we call this function on all OS, but NOT on FreeBSD or Cygwin,
      * because it crashes with no reason (bug in Perl?)
