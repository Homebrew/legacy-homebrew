require 'formula'

class Weechat < Formula
  homepage 'http://www.weechat.org'
  url 'http://weechat.org/files/src/weechat-1.0.tar.bz2'
  sha1 'd3070ffde05cb706d615144e71f933153871894d'
  revision 1

  head 'https://github.com/weechat/weechat.git'

  bottle do
    sha1 "ffe3cecdb9b796eae6fd6db61aa8b9ea9c5bc6b4" => :mavericks
    sha1 "a308dce7ebecc1bae28a9a3aafe1ee44161da42b" => :mountain_lion
    sha1 "3127000fe74e0911ae006d035aa72112cdb84047" => :lion
  end

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
    args << '-DENABLE_LUA=OFF'    if build.without? 'lua'
    args << '-DENABLE_PERL=OFF'   if build.without? 'perl'
    args << '-DENABLE_RUBY=OFF'   if build.without? 'ruby'
    args << '-DENABLE_ASPELL=OFF' if build.without? 'aspell'
    args << '-DENABLE_GUILE=OFF'  if build.without? 'guile'
    args << '-DENABLE_PYTHON=OFF' if build.without? 'python'

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
