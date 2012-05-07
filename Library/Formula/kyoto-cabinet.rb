require 'formula'

class KyotoCabinet < Formula
  homepage 'http://fallabs.com/kyotocabinet/'
  url 'http://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.75.tar.gz'
  sha1 'ab4d59ca575455328f2b63628cc33c70d666570c'

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
