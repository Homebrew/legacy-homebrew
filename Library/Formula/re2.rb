class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"

  stable do
    url "https://github.com/google/re2/archive/2015-08-01.tar.gz"
    version "20150801"
    sha256 "0fd7388097dcc7b26a8fc7c4e704e2831d264015818fa3f13665f36d40afabf8"
  end

  head "https://github.com/google/re2.git"

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
