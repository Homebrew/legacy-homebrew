require 'formula'

class Weechat < Formula
  homepage 'http://www.weechat.org'
  url 'http://www.weechat.org/files/src/weechat-0.3.8.tar.bz2'
  sha1 '50387983f3aa20946a0b3d466acafa35f86411f5'

  depends_on 'cmake' => :build
  depends_on 'gettext'
  depends_on 'gnutls'
  depends_on 'guile'  => :optional if build.include? 'guile'
  depends_on 'aspell' => :optional if build.include? 'aspell'
  depends_on 'lua'    => :optional if build.include? 'lua'

  option 'lua', 'Build the lua module'
  option 'perl', 'Build the perl module'
  option 'ruby', 'Build the ruby module'
  option 'guile', 'Build the guile module'
  option 'python', 'Build the python module (requires framework Python)'
  option 'aspell', 'Build the aspell module that checks your spelling'

  def install
    # Remove all arch flags from the PERL_*FLAGS as we specify them ourselves.
    # This messes up because the system perl is a fat binary with 32, 64 and PPC
    # compiles, but our deps don't have that. Remove at v0.3.8, fixed in HEAD.
    archs = %W[-arch ppc -arch i386 -arch x86_64].join('|')
    inreplace  "src/plugins/scripts/perl/CMakeLists.txt",
      'IF(PERL_FOUND)',
      'IF(PERL_FOUND)' +
      %Q{\n  STRING(REGEX REPLACE "#{archs}" "" PERL_CFLAGS "${PERL_CFLAGS}")} +
      %Q{\n  STRING(REGEX REPLACE "#{archs}" "" PERL_LFLAGS "${PERL_LFLAGS}")}

    # FindPython.cmake queries the Python variable LINKFORSHARED which contains
    # a path that only exists during Python install when using HB framework
    # Python.  So remove that and use what's common in every install of Python,
    # namely -u _PyMac_Error.  Without the invalid path, it links okay.
    # Because Macports and Apple change LINKFORSHARED but HB does not, this
    # will have to persist, and it's not reported upstream.  Fixes the error
    #   no such file or directory: 'Python.framework/Versions/2.7/Python'
    inreplace 'src/plugins/scripts/python/CMakeLists.txt',
      '${PYTHON_LFLAGS}', '-u _PyMac_Error'

    args = std_cmake_args + %W[
      -DPREFIX=#{prefix}
      -DENABLE_GTK=OFF
    ]
    args << '-DENABLE_LUA=OFF'    unless build.include? 'lua'
    args << '-DENABLE_PERL=OFF'   unless build.include? 'perl'
    args << '-DENABLE_RUBY=OFF'   unless build.include? 'ruby'
    args << '-DENABLE_PYTHON=OFF' unless build.include? 'python'
    args << '-DENABLE_ASPELL=OFF' unless build.include? 'aspell'
    args << '-DENABLE_GUILE=OFF'  unless build.include? 'guile' and \
                                         Formula.factory('guile').linked_keg.exist?
    args << '.'

    system 'cmake', *args
    system 'make install'
  end

  def caveats; <<-EOS.undent
      Weechat can depend on Aspell if you choose the --aspell option, but
      Aspell should be installed manually before installing Weechat so that
      you can choose the dictionaries you want.  If Aspell was installed
      automatically as part of weechat, there won't be any dictionaries.
    EOS
  end
end
