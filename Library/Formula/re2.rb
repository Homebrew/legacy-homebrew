class Re2 < Formula
  homepage "https://github.com/google/re2"
  url "https://re2.googlecode.com/files/re2-20140304.tgz"
  sha1 "f30dda8e530921b623c32aa58a5dabbe9157f6ca"

  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    revision 2
    sha256 "5939606ce231feeca079414abe2beb98ad1e1c2393d5ba7f25f476dfd82e3ca2" => :yosemite
    sha256 "1d4eda8d4e9b3434ebe882ec05c150cc3d30f7798f0e89dc03b298de11531a23" => :mavericks
    sha256 "0c88133e1c513e2b11df6b29f691fd24a04b57e69ad330e3595bc2ccb85a8532" => :mountain_lion
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
    system "install_name_tool", "-id", "#{lib}/libre2.0.dylib", "#{lib}/libre2.0.0.0.dylib"
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.0.dylib"
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.dylib"
  end
end
