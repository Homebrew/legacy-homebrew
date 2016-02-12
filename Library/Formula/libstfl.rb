class Libstfl < Formula
  desc "Library implementing a curses-based widget set for terminals"
  homepage "http://www.clifford.at/stfl/"
  url "http://www.clifford.at/stfl/stfl-0.24.tar.gz"
  sha256 "d4a7aa181a475aaf8a8914a8ccb2a7ff28919d4c8c0f8a061e17a0c36869c090"

  bottle do
    cellar :any
    revision 1
    sha256 "8ca63ef8c7776df77eda7a327b2e4a9d413992c08605e7922a7b82f560be618a" => :yosemite
    sha256 "9a0b5e72c534ca6bc3e1ba2fbafb384719e5df9663ff4b507936afebfde16272" => :mavericks
    sha256 "f30b9c76dbd4d31b7860b8ed8c0c8024f820624880db32b00d1804d38e9e6808" => :mountain_lion
  end

  depends_on :python => :optional
  depends_on "ruby"
  depends_on "swig" => :build

  def install
    ENV.append "LDLIBS", "-liconv"
    ENV.append "LIBS", "-lncurses -lruby -liconv"

    args = ["CC=#{ENV.cc} -pthread", "prefix=#{prefix}"]

    args << "FOUND_RUBY = 0" unless MacOS::CLT.installed? || MacOS.version >= :mavericks

    # Install into the site-packages in the Cellar (so uninstall works)
    inreplace "python/Makefile.snippet" do |s|
      s.change_make_var! "PYTHON_SITEARCH", lib/"python2.7/site-packages"
      s.gsub! "lib-dynload/", ""
    end

    if build.with? "python"
      # Fails race condition of test:
      #   ImportError: dynamic module does not define init function (init_stfl)
      #   make: *** [python/_stfl.so] Error 1
      ENV.deparallelize
    else
      args << "FOUND_PYTHON = 0"
    end

    [ "Makefile",
      "stfl.pc.in",
      "perl5/Makefile.PL",
      "python/Makefile.snippet",
      "ruby/Makefile.snippet",
    ].each do |f|
       inreplace f, "ncursesw", "ncurses"
    end
    inreplace "stfl_internals.h", "ncursesw/ncurses.h", "ncurses.h"
    inreplace "Makefile", "-Wl,-soname,$(SONAME)", "-Wl"
    inreplace "Makefile", "libstfl.so.$(VERSION)", "libstfl.$(VERSION).dylib"
    inreplace "Makefile", "libstfl.so", "libstfl.dylib"

    inreplace "python/Makefile.snippet", "gcc", "$(CC)"
    inreplace "python/Makefile.snippet", "-lncurses", "-lncurses -liconv"
    inreplace "python/Makefile.snippet", "-I/usr/include/python$(PYTHON_VERSION)", "-L#{`python-config --prefix`.strip}/lib #{`python-config --include`.strip} #{`python-config --ldflags`.strip}"

    system "make"

    inreplace "perl5/Makefile", "Network/Library", etc

    system "make", "install", *args
  end
end
