class Global < Formula
  desc "Source code tag system"
  homepage "https://www.gnu.org/software/global/"
  url "http://ftpmirror.gnu.org/global/global-6.5.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/global/global-6.5.1.tar.gz"
  sha256 "0e9d5227d400e8cb2ffa1732d98b8735d58d4bf8476c2845365770fdd5b264f8"

  bottle do
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
        assert shell_output("#{bin}/global -d cfunc").include?("test.c")
        assert shell_output("#{bin}/global -d c2func").include?("test.c")
        assert shell_output("#{bin}/global -r c2func").include?("test.c")
        assert shell_output("#{bin}/global -s cvar").include?("test.c")
        assert shell_output("#{bin}/global -d pyfunc").include?("test.py")
        assert shell_output("#{bin}/global -r py2func").include?("test.py")
        assert shell_output("#{bin}/global -s pyvar").include?("test.py")
      else
        # Everything is a symbol in this case
        assert shell_output("#{bin}/global -s cfunc").include?("test.c")
        assert shell_output("#{bin}/global -s c2func").include?("test.c")
        assert shell_output("#{bin}/global -s cvar").include?("test.c")
        assert shell_output("#{bin}/global -s pyfunc").include?("test.py")
        assert shell_output("#{bin}/global -s py2func").include?("test.py")
        assert shell_output("#{bin}/global -s pyvar").include?("test.py")
      end
    end
    if build.with? "exuberant-ctags"
      assert shell_output("#{bin}/gtags --gtagsconf=#{share}/gtags/gtags.conf --gtagslabel=exuberant-ctags .")
      # ctags only yields definitions
      assert shell_output("#{bin}/global -d cfunc   # passes").include?("test.c")
      assert shell_output("#{bin}/global -d c2func  # passes").include?("test.c")
      assert !shell_output("#{bin}/global -r c2func  # correctly fails").include?("test.c")
      assert !shell_output("#{bin}/global -s cvar    # correctly fails").include?("test.c")
      assert shell_output("#{bin}/global -d pyfunc  # passes").include?("test.py")
      assert shell_output("#{bin}/global -d py2func # passes").include?("test.py")
      assert !shell_output("#{bin}/global -r py2func # correctly fails").include?("test.py")
      assert !shell_output("#{bin}/global -s pyvar   # correctly fails").include?("test.py")
    end
    if build.with? "sqlite3"
      assert shell_output("#{bin}/gtags --sqlite3 --gtagsconf=#{share}/gtags/gtags.conf --gtagslabel=default .")
      assert shell_output("#{bin}/global -d cfunc").include?("test.c")
      assert shell_output("#{bin}/global -d c2func").include?("test.c")
      assert shell_output("#{bin}/global -r c2func").include?("test.c")
      assert shell_output("#{bin}/global -s cvar").include?("test.c")
    end
    # C should work with default parser for any build
    assert shell_output("#{bin}/gtags --gtagsconf=#{share}/gtags/gtags.conf --gtagslabel=default .")
    assert shell_output("#{bin}/global -d cfunc").include?("test.c")
    assert shell_output("#{bin}/global -d c2func").include?("test.c")
    assert shell_output("#{bin}/global -r c2func").include?("test.c")
    assert shell_output("#{bin}/global -s cvar").include?("test.c")
  end
end
