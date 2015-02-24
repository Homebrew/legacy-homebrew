class Global < Formula
  homepage "https://www.gnu.org/software/global/"
  url "http://ftpmirror.gnu.org/global/global-6.3.4.tar.gz"
  mirror "https://ftp.gnu.org/gnu/global/global-6.3.4.tar.gz"
  sha1 "6b73c0b3c7eea025c8004f8d82d836f2021d0c9e"

  bottle do
    revision 1
    sha1 "bb61eb5f9f950d47eaaa856c7fb18b354256d646" => :yosemite
    sha1 "b295a8b0f40f07fccec741217dc05c38a4d42bc8" => :mavericks
    sha1 "23d4ba161767bfe1d688442df1325a28cf0cc657" => :mountain_lion
  end

  head do
    url ":pserver:anonymous:@cvs.savannah.gnu.org:/sources/global", :using => :cvs

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-exuberant-ctags", "Enable Exuberant Ctags as a plug-in parser"
  option "with-pygments", "Enable Pygments as a plug-in parser (should enable exuberent-ctags too)"

  depends_on "ctags" if build.with? "exuberant-ctags"

  skip_clean "lib/gtags"

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-1.6.tar.gz"
    sha1 "53d831b83b1e4d4f16fec604057e70519f9f02fb"
  end

  def install
    system "sh", "reconf.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

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
    # C should work with default parser for any build
    assert shell_output("#{bin}/gtags --gtagsconf=#{share}/gtags/gtags.conf --gtagslabel=default .")
    assert shell_output("#{bin}/global -d cfunc").include?("test.c")
    assert shell_output("#{bin}/global -d c2func").include?("test.c")
    assert shell_output("#{bin}/global -r c2func").include?("test.c")
    assert shell_output("#{bin}/global -s cvar").include?("test.c")
  end
end
