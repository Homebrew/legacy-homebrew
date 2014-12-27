class Weechat < Formula
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-1.0.1.tar.gz"
  sha1 "1d33591b6c0adc2c30b36a7b349603cbdbcb40b2"

  devel do
    url "https://github.com/weechat/weechat/archive/v1.1-rc1.tar.gz"
    sha1 "3cf06cfead34fe351a0e3eb53144cbf3f68bc7e5"
    version "1.1-rc1"
  end

  head "https://github.com/weechat/weechat.git"

  bottle do
    sha1 "d7112142ed11d2a1a55b367e01e0200b5ba0cae6" => :mavericks
    sha1 "39d482d54d391ce27a0aff4de22b5a122ab27275" => :mountain_lion
    sha1 "8cfbd8d53a85b88138bff6c4545efa955fa30c26" => :lion
  end

  option "with-perl", "Build the perl module"
  option "with-ruby", "Build the ruby module"
  option "with-curl", "Build with brewed curl"

  depends_on "cmake" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "gettext"
  depends_on "guile" => :optional
  depends_on "aspell" => :optional
  depends_on "lua" => :optional
  depends_on :python => :optional
  depends_on "curl" => :optional

  def install
    # builds against the python in PATH by asking cmake to use introspected
    # values instead of ignoring them
    # https://github.com/weechat/weechat/pull/217
    if build.stable?
      inreplace "cmake/FindPython.cmake", "PATHS ${", "HINTS ${"
    end

    args = std_cmake_args

    args << "-DENABLE_LUA=OFF"    if build.without? "lua"
    args << "-DENABLE_PERL=OFF"   if build.without? "perl"
    args << "-DENABLE_RUBY=OFF"   if build.without? "ruby"
    args << "-DENABLE_ASPELL=OFF" if build.without? "aspell"
    args << "-DENABLE_GUILE=OFF"  if build.without? "guile"
    args << "-DENABLE_PYTHON=OFF" if build.without? "python"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  def caveats; <<-EOS.undent
      Weechat can depend on Aspell if you choose the --with-aspell option, but
      Aspell should be installed manually before installing Weechat so that
      you can choose the dictionaries you want.  If Aspell was installed
      automatically as part of weechat, there won't be any dictionaries.
    EOS
  end

  test do
    ENV["TERM"] = "xterm"
    system "weechat", "-r", "/quit"
  end
end
