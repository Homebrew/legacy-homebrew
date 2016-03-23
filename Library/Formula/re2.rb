class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  head "https://github.com/google/re2.git"

  stable do
    url "https://github.com/google/re2/archive/2016-03-01.tar.gz"
    version "20160301"
    sha256 "2dc6188270fe83660ccb379ef2d5ce38e0e38ca0e1c0b3af4b2b7cf0d8c9c11a"
  end

  bottle do
    cellar :any
    sha256 "3d23d9919dca4ac70d5c7d675b055a5ce6628103314e001b0b891448da71883e" => :el_capitan
    sha256 "43f1a2e5dab1357d1ae7e0bce0d21a7a905f2083eab6f7aadaba214e267492c6" => :yosemite
    sha256 "461fac19a240edb44c105a8f05ff30ed53c1f665e7bfd6f94cf8e2998252684a" => :mavericks
  end

  def install
    system "make", "install", "prefix=#{prefix}"
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
