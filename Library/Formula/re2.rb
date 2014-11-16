require 'formula'

class Re2 < Formula
  homepage 'https://code.google.com/p/re2/'
  url 'https://re2.googlecode.com/files/re2-20140304.tgz'
  sha1 'f30dda8e530921b623c32aa58a5dabbe9157f6ca'

  head 'https://re2.googlecode.com/hg'

  bottle do
    cellar :any
    revision 1
    sha1 "c502279673f7a522964161813c1d284d3dd12115" => :mavericks
    sha1 "ed4e24ef60a2c44af9ed67b22d6f983f3177f0fc" => :mountain_lion
    sha1 "50250f3de155321a6b93276f0df967e868fc4ca8" => :lion
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
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.0.dylib"
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.dylib"
  end
end
