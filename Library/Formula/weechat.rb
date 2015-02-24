class Weechat < Formula
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-1.1.tar.gz"
  sha1 "8cc055051b0df6755e8310e4fd624623707e81dc"

  head "https://github.com/weechat/weechat.git"

  bottle do
    sha1 "e36f032f19ec591c3d7864e2a95ca9afe3ba1771" => :yosemite
    sha1 "02d3c62b3ff86ac19b9c5ac0e972f63a5746a52e" => :mavericks
    sha1 "ec70b13654147081d8b8823bee45ee99542dd96c" => :mountain_lion
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
