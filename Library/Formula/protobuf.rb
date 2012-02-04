require 'formula'

class Protobuf < Formula
  url 'http://protobuf.googlecode.com/files/protobuf-2.4.1.tar.bz2'
  homepage 'http://code.google.com/p/protobuf/'
  sha1 'df5867e37a4b51fb69f53a8baf5b994938691d6d'

  fails_with_llvm :build => 2334

  def options
    [['--universal', 'Do a universal build']]
  end

  def options
      [
        ["--install-python", "Install Python protobuf package (requires Homebrew-built Python)"],
      ]
  end

  def install
    # Don't build in debug mode. See:
    # https://github.com/mxcl/homebrew/issues/9279
    # http://code.google.com/p/protobuf/source/browse/trunk/configure.ac#61
    ENV.prepend 'CXXFLAGS', '-DNDEBUG'
    ENV.universal_binary if ARGV.build_universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zlib"
    system "make"
    system "make install"

    if ARGV.include? "--install-python"
      python = Formula.factory("python")
      unless python.installed?
        onoe "The \"--install-python\" option requires a Homebrew-built Python."
        exit 99
      end

      cd 'python' do
        # Note: setup.py currently requires setuptools (or distribute)
        system "#{python.bin}/python", "setup.py", "install"
      end
    end
  end
end
