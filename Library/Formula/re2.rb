class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2015-07-01.tar.gz"
  version "20150701"
  sha256 "e32d6dfa48d882a81086ae26537dc2e78877bb427f61c8cd4062dff7d0b0ef08"

  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "dcae1c0aa876d8c29a5709c0be1851160add2b1da08cf39c397142a0dc390d3e" => :yosemite
    sha256 "f6cb3be5ae300793b9586bdbbb5d1dc4fa687c7daf8aa97bad01a9f038688828" => :mavericks
    sha256 "12ca2b816825736994556b43a7a6d2804b88537fdcc2d5112ad3a36017b6f510" => :mountain_lion
  end

  def install
    # https://code.google.com/p/re2/issues/detail?id=99
    if ENV.compiler != :clang || MacOS.version < :mavericks
      inreplace "libre2.symbols.darwin",
                # operator<<(std::__1::basic_ostream<char, std::__1::char_traits<char> >&, re2::StringPiece const&)
                "__ZlsRNSt3__113basic_ostreamIcNS_11char_traitsIcEEEERKN3re211StringPieceE",
                # operator<<(std::ostream&, re2::StringPiece const&)
                "__ZlsRSoRKN3re211StringPieceE"
    end
    system "make", "install", "prefix=#{prefix}"
    mv lib/"libre2.so.0.0.0", lib/"libre2.0.0.0.dylib"
    system "install_name_tool", "-id", "#{lib}/libre2.0.dylib", "#{lib}/libre2.0.0.0.dylib"
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.0.dylib"
    lib.install_symlink "libre2.0.0.0.dylib" => "libre2.dylib"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lre2",
           testpath/"test.cpp", "-o", "test"
    system "./test"
  end
end
