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
    revision 1
    sha1 "e5cbebaca9b73342b07bf8302eb78157a8929660" => :yosemite
    sha1 "36a7f4ac899bd4aec97a6cdba9c769bc1b0815c8" => :mavericks
    sha1 "a76c212cf886cef42113bef355936ac58ff3084a" => :mountain_lion
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
