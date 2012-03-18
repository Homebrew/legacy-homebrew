require 'formula'

class KyotoCabinet < Formula
  homepage 'http://fallabs.com/kyotocabinet/'
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.74.tar.gz'
  sha1 '345358259ec4e58b5986b5d6fa8f82dfe2816c37'

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
