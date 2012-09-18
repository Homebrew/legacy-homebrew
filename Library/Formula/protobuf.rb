require 'formula'

class Protobuf < Formula
  homepage 'http://code.google.com/p/protobuf/'
  url 'http://protobuf.googlecode.com/files/protobuf-2.4.1.tar.bz2'
  sha1 'df5867e37a4b51fb69f53a8baf5b994938691d6d'

  option :universal

  fails_with :llvm do
    build 2334
  end

  def install
    # Don't build in debug mode. See:
    # https://github.com/mxcl/homebrew/issues/9279
    # http://code.google.com/p/protobuf/source/browse/trunk/configure.ac#61
    ENV.prepend 'CXXFLAGS', '-DNDEBUG'
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-zlib"
    system "make"
    system "make install"

    # Install editor support and examples
    doc.install %w( editors examples )
  end

  def caveats; <<-EOS.undent
    Editor support and examples have been installed to:
      #{doc}/protobuf
    EOS
  end
end
