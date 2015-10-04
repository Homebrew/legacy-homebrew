class Binwalk < Formula
  desc "Searches a binary image for embedded files and executable code"
  homepage "http://binwalk.org/"
  revision 1
  stable do
    url "https://github.com/devttys0/binwalk/archive/v2.0.1.tar.gz"
    sha256 "90ee8426d71e91b62dfe4a1446c457bc7835b475b28717859e275a0494403959"

    # Fixes OS-X-specific issues no longer relevant in HEAD:
    #
    # * Fixes OS X bug in 'setup.py':
    #   * See <https://github.com/devttys0/binwalk/commit/8278229cae4c2c354ffc5bfc3bcef0fd1d9bf2b3>
    #     and <https://github.com/devttys0/binwalk/commit/76ff729a19552e6e58505ca64b1d4ce2325e7ac0>.
    # * Fixes library lookup for non-standard Homebrew installations:
    #   * See upstream issue <https://github.com/devttys0/binwalk/issues/130>
    #     for the details.
    #   * The fix is Homebrew-specific as it uses HOMEBREW_PREFIX, that is
    #     implicitly replace with the actual Homebrew prefix, in the patch.
    patch :DATA
  end

  bottle do
    revision 2
    sha256 "c2d9e5ebb894369ea7013bfd807804c9cddfb55a9c48ccfd465cc4089e83f706" => :el_capitan
    sha256 "0f82745a58604fd03f88fd41a6a0b4c3408982c5aa31e099f421a641a1c67520" => :yosemite
    sha256 "2371ec0e725e8ade778849e1ad6fc9c5aaef2887d0e2052c32ab2c992413db88" => :mavericks
    sha256 "0e95d22e718e204bff65a768fc925afbacd612c77969f638731cdfa2f439a61a" => :mountain_lion
  end

  head do
    url "https://github.com/devttys0/binwalk.git"

    option "with-capstone", "Enable disasm options via capstone"
    resource "capstone" do
      url "https://pypi.python.org/packages/source/c/capstone/capstone-3.0.2.tar.gz"
      sha256 "b32022fe956e940f8e67c17841dd3f6f1c50a60e451f9b5ce1f4dd2e5c5b3339"
    end
  end

  option "with-matplotlib", "Check for presence of matplotlib, which is required for entropy graphing support"

  depends_on "swig" => :build
  depends_on :fortran
  depends_on "libmagic" => "with-python"
  depends_on "matplotlib" => :python if build.with? "matplotlib"
  depends_on "pyside"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "p7zip"
  depends_on "ssdeep"
  depends_on "xz"

  resource "pyqtgraph" do
    url "http://www.pyqtgraph.org/downloads/pyqtgraph-0.9.10.tar.gz"
    sha256 "4c0589774e3c8b0c374931397cf6356b9cc99a790215d1917bb7f015c6f0729a"
  end

  resource "numpy" do
    url "https://downloads.sourceforge.net/project/numpy/NumPy/1.9.2/numpy-1.9.2.tar.gz"
    sha256 "325e5f2b0b434ecb6e6882c7e1034cc6cdde3eeeea87dbc482575199a6aeef2a"
  end

  resource "scipy" do
    url "https://downloads.sourceforge.net/project/scipy/scipy/0.15.1/scipy-0.15.1.tar.gz"
    sha256 "a212cbc3b79e9a563aa45fc5c517b3499198bd7eb7e7be1e047568a5f48c259a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    res = %w[numpy scipy pyqtgraph]
    res += %w[capstone] if build.with? "capstone"
    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    if build.head?
      ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
      system "python", *Language::Python.setup_install_args(libexec)
      bin.install Dir["#{libexec}/bin/*"]
      bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    else
      system "./configure", "--prefix=#{prefix}", "--disable-bundles"
      system "make", "install"
    end
  end

  test do
    touch "binwalk.test"
    system "#{bin}/binwalk", "binwalk.test"
  end
end

__END__
diff --git a/setup.py b/setup.py
index b5fbf54..660091d 100755
--- a/setup.py
+++ b/setup.py
@@ -134,7 +134,7 @@ if "install" in sys.argv or "build" in sys.argv:

 # The data files to install along with the module
 data_dirs = ["magic", "config", "plugins", "modules", "core"]
-install_data_files = [os.path.join("libs", "*.so")]
+install_data_files = [os.path.join("libs", "*.so"), os.path.join("libs", "*.dylib")]

 for data_dir in data_dirs:
     install_data_files.append("%s%s*" % (data_dir, os.path.sep))
diff --git a/src/binwalk/core/C.py b/src/binwalk/core/C.py
index e492a22..f8b3bd3 100644
--- a/src/binwalk/core/C.py
+++ b/src/binwalk/core/C.py
@@ -125,10 +125,7 @@ class Library(object):
                 'linux'   : [os.path.join(prefix, 'lib%s.so' % library), '/usr/local/lib/lib%s.so' % library],
                 'cygwin'  : [os.path.join(prefix, 'lib%s.so' % library), '/usr/local/lib/lib%s.so' % library],
                 'win32'   : [os.path.join(prefix, 'lib%s.dll' % library), '%s.dll' % library],
-                'darwin'  : [os.path.join(prefix, 'lib%s.dylib' % library),
-                             '/opt/local/lib/lib%s.dylib' % library,
-                             '/usr/local/lib/lib%s.dylib' % library,
-                            ] + glob.glob('/usr/local/Cellar/*%s*/*/lib/lib%s.dylib' % (library, library)),
+                'darwin'  : [os.path.join(prefix, 'lib%s.dylib' % library), 'HOMEBREW_PREFIX/lib/lib%s.dylib' % library],
             }

             for i in range(2, 4):
