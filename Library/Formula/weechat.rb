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

  def patches
    # Weechat uses a Python variable that's not designed for external progs.
    # LINKFORSHARED is used by Python's Makefiles internally and doesn't point
    # to a directory that exists.  This is unreported at this time but will be
    # filed with the weechat developers along with the Ruby hacks being tested.
    DATA if python? and python_framework?
  end

  def install
    # Weechat has problems finding Ruby Libraries and Includes, but it uses
    # an outdated FindRuby.cmake.  cp the Homebrew one and try that.
    if ruby? then
      modules = "#{Formula.factory('cmake').share}/cmake/Modules"
      cp "#{modules}/FindPackageHandleStandardArgs.cmake", './cmake'
      cp "#{modules}/FindRuby.cmake", './cmake'
    end

    # Remove all arch flags from the PERL_*FLAGS as we specify them ourselves.
    # This messes up because the system perl is a fat binary with 32, 64 and PPC
    # compiles, but our deps don't have that.  This is fixed in HEAD.
    # Remove at version 0.3.8.
    unless ARGV.build_head? then
      archs = ['-arch ppc', '-arch i386', '-arch x86_64'].join('|')
      inreplace  "src/plugins/scripts/perl/CMakeLists.txt",
        'IF(PERL_FOUND)',
        'IF(PERL_FOUND)' +
        %Q{\n  STRING(REGEX REPLACE "#{archs}" "" PERL_CFLAGS "${PERL_CFLAGS}")} +
        %Q{\n  STRING(REGEX REPLACE "#{archs}" "" PERL_LFLAGS "${PERL_LFLAGS}")}
    end

    # -DPREFIX has to be specified because weechat devs enjoy being non-standard
    args = std_cmake_parameters.split + %W[ -DPREFIX=#{prefix} ]
    args << '-DENABLE_RUBY=OFF' unless ruby?
    args << '-DENABLE_PERL=OFF' unless perl?

    if python?
      if python_framework?
        args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
        args << "-DPYTHON_INCLUDE_PATH='#{python_prefix}/Headers'"
      else
        python_version = `python-config --libs`.match('-lpython(\d+\.\d+)').captures.at(0)
        python_lib = "#{python_prefix}/lib/libpython#{python_version}"
        args << "-DPYTHON_INCLUDE_PATH='#{python_prefix}/include/python#{python_version}'"
        if File.exists? "#{python_lib}.a"
          args << "-DPYTHON_LIBRARY='#{python_lib}.a'"
        else
          args << "-DPYTHON_LIBRARY='#{python_lib}.dylib'"
        end
      end
    else
      args << '-DENABLE_PYTHON=OFF'
    end

    args << '.'
    system "cmake", *args
    system 'make install'
  end

  def caveats; <<-EOS.undent
    If you build weechat with --enable-python, then amend your PYTHONPATH like so:
      export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
    EOS
  end

  def python?; ARGV.include? '--enable-python'; end
  def ruby?; ARGV.include? '--enable-ruby'; end
  def perl?; ARGV.include? '--enable-perl'; end

  def python_prefix
    python_prefix = `python-config --prefix`.strip
  end

  def python_framework?
    # Python was compiled with --framework:
    File.exist? "#{python_prefix}/Python"
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end

__END__
--- a/cmake/FindPython.cmake	2012-01-08 02:15:27.000000000 -0800
+++ b/cmake/FindPython.cmake	2012-04-29 18:55:03.000000000 -0700
@@ -49,10 +49,7 @@
     OUTPUT_VARIABLE PYTHON_POSSIBLE_LIB_PATH
     )
 
-  EXECUTE_PROCESS(
-    COMMAND ${PYTHON_EXECUTABLE} -c "from distutils.sysconfig import *; print(get_config_var('LINKFORSHARED'))"
-    OUTPUT_VARIABLE PYTHON_LFLAGS
-    )
+  SET(PYTHON_LFLAGS "-u _PyMac_Error")
 
   # remove the new lines from the output by replacing them with empty strings
   STRING(REPLACE "\n" "" PYTHON_INC_DIR "${PYTHON_INC_DIR}")
