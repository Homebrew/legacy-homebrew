class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-1.3.tar.gz"
  sha256 "5c6c8f21f4835034c78c9f86f70c8df76afa73897481e84261e1583db46b678d"

  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "446877e86103bbadb12ba04760ef015adc4be1cafc1c0969b0b193682d9023b1" => :el_capitan
    sha256 "9fc15ea386d67e7e25948c3808b59feb3b93e6cd8d38b0c9cf07129aaaec05e7" => :yosemite
    sha256 "a98f706a26238b79fa5d4c86bc126bb299623a01a7a7de507fbb217e2f45b4c3" => :mavericks
    sha256 "88145b0f3689ab894957952d8c89c02ecd17b14b2f936bac2711744f2a9d2c99" => :mountain_lion
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

    args << "-DENABLE_LUA=OFF" if build.without? "lua"
    args << "-DENABLE_PERL=OFF" if build.without? "perl"
    args << "-DENABLE_RUBY=OFF" if build.without? "ruby"
    args << "-DENABLE_ASPELL=OFF" if build.without? "aspell"
    args << "-DENABLE_GUILE=OFF" if build.without? "guile"
    args << "-DENABLE_PYTHON=OFF" if build.without? "python"
    args << "-DENABLE_JAVASCRIPT=OFF"

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
