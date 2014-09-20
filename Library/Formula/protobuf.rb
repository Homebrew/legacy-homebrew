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
