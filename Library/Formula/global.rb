class Global < Formula
  desc "Source code tag system"
  homepage "https://www.gnu.org/software/global/"
  url "http://ftpmirror.gnu.org/global/global-6.5.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/global/global-6.5.1.tar.gz"
  sha256 "0e9d5227d400e8cb2ffa1732d98b8735d58d4bf8476c2845365770fdd5b264f8"

  bottle do
    sha256 "2c15f88285fc7eeb875e73808eac0f577335c7cf1c1727020909c48381aea623" => :el_capitan
    sha256 "20b49507cf026b517f1b0a855f0cbf804ae16a20f2fe5073f2b1b957e95514ec" => :yosemite
    sha256 "0b132bd00315344cf41234882274d50b2a36fe97647d05cc805571c05ddaf314" => :mavericks
  end

  head do
    url ":pserver:anonymous:@cvs.savannah.gnu.org:/sources/global", :using => :cvs

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-exuberant-ctags", "Enable Exuberant Ctags as a plug-in parser"
  option "with-pygments", "Enable Pygments as a plug-in parser (should enable exuberent-ctags too)"
  option "with-sqlite3", "Use SQLite3 API instead of BSD/DB API for making tag files"

  depends_on "ctags" if build.with? "exuberant-ctags"

  skip_clean "lib/gtags"

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha256 "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51"
  end

  def install
    system "sh", "reconf.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    args << "--with-sqlite3" if build.with? "sqlite3"

    if build.with? "exuberant-ctags"
      args << "--with-exuberant-ctags=#{Formula["ctags"].opt_bin}/ctags"
    end

    if build.with? "pygments"
      ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
      pygments_args = %W[build install --prefix=#{libexec}]
      resource("pygments").stage { system "python", "setup.py", *pygments_args }
    end

    system "./configure", *args
    system "make", "install"

    if build.with? "pygments"
      bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    end

    inreplace "gtags.conf", prefix, opt_prefix
    etc.install "gtags.conf"

    # we copy these in already
    cd share/"gtags" do
      rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
    end
  end
  test do
    (testpath/"test.c").write <<-EOF.undent
       int c2func (void) { return 0; }
       void cfunc (void) {int cvar = c2func(); }")
    EOF
    if build.with?("pygments") || build.with?("exuberant-ctags")
      (testpath/"test.py").write <<-EOF
        def py2func ():
             return 0
        def pyfunc ():
             pyvar = py2func()
      EOF
    end
    if build.with? "pygments"
      assert shell_output("#{bin}/gtags --gtagsconf=#{share}/gtags/gtags.conf --gtagslabel=pygments .")
      if build.with? "exuberant-ctags"
        assert_match /test\.c/, shell_output("#{bin}/global -d cfunc")
        assert_match /test\.c/, shell_output("#{bin}/global -d c2func")
        assert_match /test\.c/, shell_output("#{bin}/global -r c2func")
        assert_match /test\.c/, shell_output("#{bin}/global -s cvar")
        assert_match /test\.py/, shell_output("#{bin}/global -d pyfunc")
        assert_match /test\.py/, shell_output("#{bin}/global -r py2func")
        assert_match /test\.py/, shell_output("#{bin}/global -s pyvar")
      else
        # Everything is a symbol in this case
        assert_match /test\.c/, shell_output("#{bin}/global -s cfunc")
        assert_match /test\.c/, shell_output("#{bin}/global -s c2func")
        assert_match /test\.c/, shell_output("#{bin}/global -s cvar")
        assert_match /test\.py/, shell_output("#{bin}/global -s pyfunc")
        assert_match /test\.py/, shell_output("#{bin}/global -s py2func")
        assert_match /test\.py/, shell_output("#{bin}/global -s pyvar")
      end
    end
    if build.with? "exuberant-ctags"
      assert shell_output("#{bin}/gtags --gtagsconf=#{share}/gtags/gtags.conf --gtagslabel=exuberant-ctags .")
      # ctags only yields definitions
      assert_match /test\.c/, shell_output("#{bin}/global -d cfunc   # passes")
      assert_match /test\.c/, shell_output("#{bin}/global -d c2func  # passes")
      assert_no_match /test\.c/, shell_output("#{bin}/global -r c2func  # correctly fails")
      assert_no_match /test\.c/, shell_output("#{bin}/global -s cvar    # correctly fails")
      assert_match /test\.py/, shell_output("#{bin}/global -d pyfunc  # passes")
      assert_match /test\.py/, shell_output("#{bin}/global -d py2func # passes")
      assert_no_match /test\.py/, shell_output("#{bin}/global -r py2func # correctly fails")
      assert_no_match /test\.py/, shell_output("#{bin}/global -s pyvar   # correctly fails")
    end
    if build.with? "sqlite3"
      assert shell_output("#{bin}/gtags --sqlite3 --gtagsconf=#{share}/gtags/gtags.conf --gtagslabel=default .")
      assert_match /test\.c/, shell_output("#{bin}/global -d cfunc")
      assert_match /test\.c/, shell_output("#{bin}/global -d c2func")
      assert_match /test\.c/, shell_output("#{bin}/global -r c2func")
      assert_match /test\.c/, shell_output("#{bin}/global -s cvar")
    end
    # C should work with default parser for any build
    assert shell_output("#{bin}/gtags --gtagsconf=#{share}/gtags/gtags.conf --gtagslabel=default .")
    assert_match /test\.c/, shell_output("#{bin}/global -d cfunc")
    assert_match /test\.c/, shell_output("#{bin}/global -d c2func")
    assert_match /test\.c/, shell_output("#{bin}/global -r c2func")
    assert_match /test\.c/, shell_output("#{bin}/global -s cvar")
  end
end
