require 'formula'

class Protobuf < Formula
  homepage 'http://code.google.com/p/protobuf/'
  url 'https://protobuf.googlecode.com/files/protobuf-2.5.0.tar.bz2'
  sha1 '62c10dcdac4b69cc8c6bb19f73db40c264cb2726'

  bottle do
    cellar :any
    sha1 "72e17ffad4e40e1e9b15aa116238110d3a68f753" => :mavericks
    sha1 "bcc4795d8f01a0682d968e195917f79618711126" => :mountain_lion
    sha1 "51b7b27f7d5e5ffcf9b8a4d49882c2217653e5e6" => :lion
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
        ENV['PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION'] = 'cpp'
        ENV.append_to_cflags "-I#{include}"
        ENV.append_to_cflags "-L#{lib}"
        system 'python', 'setup.py', 'build'
        system 'python', 'setup.py', 'install', "--prefix=#{prefix}",
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
