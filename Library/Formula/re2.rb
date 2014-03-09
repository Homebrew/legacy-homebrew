require 'formula'

class Re2 < Formula
  homepage 'https://code.google.com/p/re2/'
  url 'https://re2.googlecode.com/files/re2-20140304.tgz'
  sha1 'f30dda8e530921b623c32aa58a5dabbe9157f6ca'

  head 'https://re2.googlecode.com/hg'

  bottle do
    cellar :any
    sha1 "77343fcc302fa0f85e1ed1483d64a449585386a0" => :mavericks
    sha1 "b45275dc3b6a80d3e6eae881c5c238f28334167e" => :mountain_lion
    sha1 "08805163f83f7e7c42316e4c2dd733548b8d7bb3" => :lion
  end

  def install
    # https://code.google.com/p/re2/issues/detail?id=99
    if ENV.compiler != :clang || MacOS.version < :mavericks
      inreplace 'libre2.symbols.darwin',
                # operator<<(std::__1::basic_ostream<char, std::__1::char_traits<char> >&, re2::StringPiece const&)
                '__ZlsRNSt3__113basic_ostreamIcNS_11char_traitsIcEEEERKN3re211StringPieceE',
                # operator<<(std::ostream&, re2::StringPiece const&)
                '__ZlsRSoRKN3re211StringPieceE'
    end
    system "make", "install", "prefix=#{prefix}"
    mv lib/"libre2.so.0.0.0", lib/"libre2.0.0.0.dylib"
    ln_s "libre2.0.0.0.dylib", lib/"libre2.0.dylib"
    ln_s "libre2.0.0.0.dylib", lib/"libre2.dylib"
  end
end
