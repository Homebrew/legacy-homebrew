require 'formula'

class Weechat < Formula
  homepage 'http://www.weechat.org'
  url 'http://weechat.org/files/src/weechat-1.0.1.tar.gz'
  sha1 '1d33591b6c0adc2c30b36a7b349603cbdbcb40b2'

  head 'https://github.com/weechat/weechat.git'

  bottle do
    sha1 "19360d0fe50646b592b78bb36353547dd1f43317" => :mavericks
    sha1 "2d4fb76df048df84fb2ec878a2964573a36f74ee" => :mountain_lion
    sha1 "add1d9b1eb865db66cae4c534c200a790e133677" => :lion
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
    # builds against the python in PATH by asking cmake to use introspected
    # values instead of ignoring them
    # https://github.com/weechat/weechat/pull/217
    inreplace "cmake/FindPython.cmake", "PATHS ${", "HINTS ${"

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
