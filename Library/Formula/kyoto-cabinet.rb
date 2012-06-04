require 'formula'

class KyotoCabinet < Formula
  homepage 'http://fallabs.com/kyotocabinet/'
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.76.tar.gz'
  sha1 'a4ec70d08ca6c8f510dbc329d5c27b55030d3521'

  fails_with :clang do
    build 318
    cause <<-EOS.undent
      Kyoto-cabinet relies on GCC atomic intrinsics, but Clang does not
      implement them for non-integer types.
    EOS
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make install"
  end
end
