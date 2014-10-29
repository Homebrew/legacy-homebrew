require 'formula'

class OldOrNoDateutilUnlessGoogleApputils < Requirement
  # https://github.com/Homebrew/homebrew/issues/32571
  # https://code.google.com/p/google-apputils-python/issues/detail?id=6
  fatal true

  satisfy(:build_env => false) {
    if can_import("dateutil") && !can_import("google.apputils")
      dateutil_version < Version.new("2.0")
    else
      true
    end
  }

  def message; <<-EOS.undent
    The protobuf Python bindings depend on the google-apputils Python library,
    which requires a version of python-dateutil less than 2.0.

    You have python-dateutil version #{dateutil_version} installed in:
      #{Pathname.new(`python -c "import dateutil; print(dateutil.__file__)"`.chomp).dirname}

    Please run:
      pip uninstall python-dateutil && pip install "python-dateutil<2"
    EOS
  end

  def can_import pymodule
    quiet_system "python", "-c", "import #{pymodule}"
  end

  def dateutil_version
    Version.new(`python -c "import dateutil; print(dateutil.__version__)"`.chomp)
  end
end

class Protobuf < Formula
  homepage 'http://code.google.com/p/protobuf/'
  url 'https://protobuf.googlecode.com/svn/rc/protobuf-2.6.0.tar.bz2', :using => :curl
  sha1 '6d9dc4c5899232e2397251f9323cbdf176391d1b'

  bottle do
    cellar :any
    revision 1
    sha1 "e0195a4905560d5869863983840b3ecad7f80c78" => :yosemite
    sha1 "d7c3d7296beb07bf3c0aa853d136beff0fdac4ce" => :mavericks
    sha1 "b751a032b13e09989e37a03b64be958f8796e80c" => :mountain_lion
  end

  option :universal
  option :cxx11

  depends_on :python => :optional
  depends_on OldOrNoDateutilUnlessGoogleApputils if build.with? "python"

  fails_with :llvm do
    build 2334
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
      chdir 'python' do
        ENV.append_to_cflags "-I#{include}"
        ENV.append_to_cflags "-L#{lib}"
        system 'python', 'setup.py', 'build'
        system 'python', 'setup.py', 'install', '--cpp_implementation', "--prefix=#{prefix}",
               '--single-version-externally-managed', '--record=installed.txt'
      end
    end
  end

  def caveats; <<-EOS.undent
    Editor support and examples have been installed to:
      #{doc}
    EOS
  end
end
