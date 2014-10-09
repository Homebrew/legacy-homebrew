require 'formula'

class Protobuf < Formula
  homepage 'http://code.google.com/p/protobuf/'
  url 'https://protobuf.googlecode.com/svn/rc/protobuf-2.6.0.tar.bz2', :using => :curl
  sha1 '6d9dc4c5899232e2397251f9323cbdf176391d1b'

  bottle do
    cellar :any
    sha1 "15ae01660cd840952b246058ecdd55e2fd01edf0" => :mavericks
    sha1 "7d7a22de4d560d3569bf6100137165b9c64d551a" => :mountain_lion
    sha1 "6a660512d05324ddefa5b3f0e633c8e8ef3aa687" => :lion
  end

  option :universal
  option :cxx11

  depends_on :python => :optional

  fails_with :llvm do
    build 2334
  end

  resource "dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.2.tar.gz"
    sha1 "fbafcd19ea0082b3ecb17695b4cb46070181699f"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2014.7.tar.bz2"
    sha1 "93f461ed9e3fb0e42becf8d7f09647daafc54d66"
  end

  resource "gflags" do
    url "https://pypi.python.org/packages/source/p/python-gflags/python-gflags-2.0.tar.gz"
    sha1 "1529a1102da2fc671f2a9a5e387ebabd1ceacbbf"
  end

  resource "google.apputils" do
    url "https://pypi.python.org/packages/source/g/google-apputils/google-apputils-0.4.0.tar.gz"
    sha1 "76a5757ede82f017c6250b46ce5f369d831ffb8f"
  end

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # http://code.google.com/p/protobuf/source/browse/trunk/configure.ac#61
    ENV.prepend 'CXXFLAGS', '-DNDEBUG'
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zlib"
    system "make"
    system "make install"

    # Install editor support and examples
    doc.install %w( editors examples )

    if build.with? 'python'
      ENV.prepend_create_path "PYTHONPATH", lib/"python2.7/site-packages"
      %w[dateutil pytz gflags].each do |r|
        next if package_installed?("python", r)
        resource(r).stage do
          system "python", "setup.py", "install", "--prefix=#{prefix}",
                 "--single-version-externally-managed", "--record=installed.txt"
        end
      end
      unless package_installed?("python", "google.apputils")
        resource("google.apputils").stage do
          # dateutil >= 2 used to be Python 3 only, but it isn't anymore
          # https://github.com/Homebrew/homebrew/issues/32571
          # https://code.google.com/p/google-apputils-python/issues/detail?id=6
          inreplace "setup.py", "python-dateutil>=1.4,<2", "python-dateutil>=1.4"
          system "python", "setup.py", "install", "--prefix=#{prefix}",
                 "--single-version-externally-managed", "--record=installed.txt"
        end
      end
      chdir 'python' do
        ENV.append_to_cflags "-I#{include}"
        ENV.append_to_cflags "-L#{lib}"

        # Hack around namespace support; google-apputils installs a .pth file
        # that helps setuptools find google.apputils even though "google" is
        # a namespace package, not a regular package (i.e. is missing
        # __init__.py). If this formula installs google-apputils, that
        # .pth file won't be processed because, although lib/.../site-packages
        # is in PYTHONPATH, python does not treat it as a special site-packages
        # directory and therefore does not interpret .pth files.
        touch lib/"python2.7/site-packages/google/__init__.py"

        system 'python', 'setup.py', 'build'
        system 'python', 'setup.py', 'install', '--cpp_implementation', "--prefix=#{prefix}",
               '--single-version-externally-managed', '--record=installed.txt'

        rm lib/"python2.7/site-packages/google/__init__.py"
      end
    end
  end

  def caveats; <<-EOS.undent
    Editor support and examples have been installed to:
      #{doc}
    EOS
  end

  def package_installed? python, module_name
    quiet_system python, "-c", "import #{module_name}"
  end
end
