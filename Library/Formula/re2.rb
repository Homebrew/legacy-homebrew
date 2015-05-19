class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2015-05-01.tar.gz"
  sha256 "35c890e61ea3f259940d236b84a5249afb698197897268868fd753ebe088c225"
  version "20150501"

  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "e5523da3475549c3cc1083db0aecce60eecd2b3dbfc64be175368d5572c0907c" => :yosemite
    sha256 "6a02685f74e9fae7b3430adab0cbbb437aa8807d7674295cd268c2d7cb2511a3" => :mavericks
    sha256 "6d4a33da323488a2f65505f24f97496952a100e165a82f7e7be902be508e2eaa" => :mountain_lion
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
