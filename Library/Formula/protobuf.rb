require 'formula'

class Protobuf <Formula
  url 'http://protobuf.googlecode.com/files/protobuf-2.3.0.tar.bz2'
  sha1 'db0fbdc58be22a676335a37787178a4dfddf93c6'
  homepage 'http://code.google.com/p/protobuf/'

  def options
      [
        ["--install-python", "Install Python protobuf package (requires Homebrew-built Python)"],
      ]
  end

  def install
    fails_with_llvm
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
