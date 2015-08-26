class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"

  stable do
    url "https://github.com/google/re2/archive/2015-07-01.tar.gz"
    version "20150701"
    sha256 "e32d6dfa48d882a81086ae26537dc2e78877bb427f61c8cd4062dff7d0b0ef08"
    # Fix the symbol table to work with both libc++ and libstdc++
    # Will be included in the next release
    # https://github.com/google/re2/issues/1
    patch do
      url "https://github.com/google/re2/commit/44cdc782e5debc2c841b3fafa9ee5a61e8c42b95.patch"
      sha256 "b1720a4f3dd0b28969600698b1aadf15bf30b9e6aef42c589d512c6a2c088579"
    end

    patch do
      url "https://github.com/google/re2/commit/a99f38705611f678f70b7e1944d188a3c28a12ab.patch"
      sha256 "22dac0b90f34b8fa693994831d1ea24b0d2f8fe49e404975a507ed744fb1de83"
    end
  end

  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "dcae1c0aa876d8c29a5709c0be1851160add2b1da08cf39c397142a0dc390d3e" => :yosemite
    sha256 "f6cb3be5ae300793b9586bdbbb5d1dc4fa687c7daf8aa97bad01a9f038688828" => :mavericks
    sha256 "12ca2b816825736994556b43a7a6d2804b88537fdcc2d5112ad3a36017b6f510" => :mountain_lion
  end

  def install
    system "make", "install", "prefix=#{prefix}"
    mv lib/"libre2.so.0.0.0", lib/"libre2.0.0.0.dylib" if build.stable?
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
