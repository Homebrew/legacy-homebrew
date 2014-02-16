require 'formula'

class Weechat < Formula
  homepage 'http://www.weechat.org'
  url 'http://www.weechat.net/files/src/weechat-0.4.3.tar.bz2'
  sha1 'c9043ae4df8057c1410eeaf4c5c8818e97963e16'

  head 'git://git.savannah.nongnu.org/weechat.git'

  depends_on 'cmake' => :build
  depends_on 'gnutls'
  depends_on 'libgcrypt'
  depends_on 'guile' => :optional
  depends_on 'aspell' => :optional
  depends_on 'lua' => :optional
  depends_on :python => :optional

  option 'with-perl', 'Build the perl module'
  option 'with-ruby', 'Build the ruby module'

  def install
    # this will fix error: 
    #    no such file or directory: 'Python.framework/Versions/2.7/Python'
    inreplace 'src/plugins/python/CMakeLists.txt',
      '${PYTHON_LFLAGS}', '-u _PyMac_Error'

    args = std_cmake_args + %W[
      -DPREFIX=#{prefix}
      -DENABLE_GTK=OFF
    ]
    args << '-DENABLE_LUA=OFF'    unless build.with? 'lua'
    args << '-DENABLE_PERL=OFF'   unless build.with? 'perl'
    args << '-DENABLE_RUBY=OFF'   unless build.with? 'ruby'
    args << '-DENABLE_ASPELL=OFF' unless build.with? 'aspell'
    args << '-DENABLE_GUILE=OFF'  unless build.with? 'guile'
    args << '-DENABLE_PYTHON=OFF' unless build.with? 'python'

    # NLS/gettext support disabled for now since it doesn't work in stdenv
    # see https://github.com/Homebrew/homebrew/issues/18722
    args << "-DENABLE_NLS=OFF"
    args << '..'

    mkdir 'build' do
      system 'cmake', *args
      system 'make install'
    end
  end

  def caveats; <<-EOS.undent
      Weechat can depend on Aspell if you choose the --with-aspell option, but
      Aspell should be installed manually before installing Weechat so that
      you can choose the dictionaries you want.  If Aspell was installed
      automatically as part of weechat, there won't be any dictionaries.
    EOS
  end
end
