require "formula"

class Global < Formula
  homepage "https://www.gnu.org/software/global/"
  url "http://ftpmirror.gnu.org/global/global-6.3.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/global/global-6.3.2.tar.gz"
  sha1 "46b681a0ccb84c928a67f6901ca60227ad71b5bd"

  bottle do
    sha1 "1bce9bd552e38d9cc12eda4998233c20a33321e4" => :mavericks
    sha1 "907a3a0180b4b4ea6ecc029b864a7ed4c8e1fa21" => :mountain_lion
    sha1 "254d7f4444b1890b1195f35a6e1f43ed34dace7d" => :lion
  end

  head do
    url "cvs://:pserver:anonymous:@cvs.savannah.gnu.org:/sources/global:global"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-exuberant-ctags", "Enable Exuberant Ctags as a plug-in parser"
  option "with-pygments", "Enable Pygments as a plug-in parser (should enable exuberent-ctags too)"

  if build.with? "exuberant-ctags"
    depends_on "ctags"
    skip_clean "lib/gtags/exuberant-ctags.la"
  end

  if build.with? "pygments"
    if build.without? "exuberant-ctags"
      opoo "suggest --with-exuberant-ctags as pygments parser symbol only without"
      "to create definition and reference tags without it all tags will be symbols"
    end
    resource 'pygments' do
      url "https://pypi.python.org/packages/source/P/Pygments/Pygments-1.6.tar.gz"
      sha1 "53d831b83b1e4d4f16fec604057e70519f9f02fb"
    end
    skip_clean "lib/gtags/pygments-parser.la"
  end

  def install
    system "sh", "reconf.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    if build.with? "exuberant-ctags"
      args << "--with-exuberant-ctags=#{HOMEBREW_PREFIX}/bin/ctags"
    end

    if build.with? "pygments"
      ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
      pygments_args = [ "build", "install", "--prefix=#{libexec}" ]
      resource('pygments').stage { system "python", "setup.py", *pygments_args }
    end

    system "./configure", *args
    system "make install"

    if build.with? "pygments"
      bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
    end

    etc.install "gtags.conf"

    # we copy these in already
    cd share/"gtags" do
      rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
    end
  end
  test do
    (testpath/'test.c').write <<-EOF.undent
       int c2func (void) { return 0; }
       void cfunc (void) {int cvar = c2func(); }")
    EOF
    if build.with? "pygments" or build.with? "exuberant-ctags"
      (testpath/'test.py').write <<-EOF
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
