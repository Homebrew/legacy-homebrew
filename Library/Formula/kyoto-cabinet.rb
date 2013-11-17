require 'formula'

class KyotoCabinet < Formula
  homepage 'http://fallabs.com/kyotocabinet/'
  url 'https://github.com/jkassemi/kyotocabinet/archive/1.2.77.tar.gz'
  sha1 '9bff7674a69022756bc32b1801941b34741e2d94'

  fails_with :clang do
    build 421
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
