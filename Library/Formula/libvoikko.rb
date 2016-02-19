class Libvoikko < Formula
  desc "Linguistic software and and Finnish dictionary"
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.0.2.tar.gz"
  sha256 "0bfaaabd039024920713020671daff828434fcf4c89bce4601b94a377567f2a3"

  # Standard compatibility fixes for Clang, upstream pull request at
  # https://github.com/voikko/corevoikko/pull/22
  patch :p2, :DATA

  bottle do
    cellar :any
    sha256 "d22047d2e96418f4f00a23dc8be15f597791d2afe73707584eb06e9482f3f83a" => :el_capitan
    sha256 "9f8ada3163060f6fe71adf9849fbd019fd1f8b1d26d0770abc7267b706342965" => :yosemite
    sha256 "f0dce2aef19383349b4fac06db0cb6f75cce8122d6279e65925103caf5fd3158" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on :python3 => :build
  depends_on "foma" => :build
  depends_on "hfstospell"

  needs :cxx11

  resource "voikko-fi" do
    url "http://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.0.tar.gz"
    sha256 "02f7595dd7e3cee188184417d6a7365f9dc653b020913f5ad75d1f14b548fafd"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko"
    system "make", "install"

    resource("voikko-fi").stage do
      ENV.append_path "PATH", bin.to_s
      system "make", "vvfst"
      system "make", "vvfst-install", "DESTDIR=#{lib}/voikko"
      lib.install_symlink "voikko"
    end
  end

  test do
    pipe_output("#{bin}/voikkospell -m", "onkohan\n")
  end
end

__END__
diff --git a/libvoikko/src/grammar/FinnishRuleEngine/VfstAutocorrectCheck.cpp b/libvoikko/src/grammar/FinnishRuleEngine/VfstAutocorrectCheck.cpp
index 30cc973..434f15b 100644
--- a/libvoikko/src/grammar/FinnishRuleEngine/VfstAutocorrectCheck.cpp
+++ b/libvoikko/src/grammar/FinnishRuleEngine/VfstAutocorrectCheck.cpp
@@ -100,7 +100,7 @@ bool VfstAutocorrectCheck::check(voikko_options_t * options, const Sentence * se
 				return false; // sentence is unreasonably long
 			}
 			for (size_t i = 0; i < token->tokenlen; i++) {
-				if (wcschr(L"\u00AD", tokenStr[i])) {
+				if (::wcschr(L"\u00AD", tokenStr[i])) {
 					skippedChars++;
 				}
 				else {
diff --git a/libvoikko/src/morphology/Analysis.cpp b/libvoikko/src/morphology/Analysis.cpp
index bc6560c..da0fc00 100644
--- a/libvoikko/src/morphology/Analysis.cpp
+++ b/libvoikko/src/morphology/Analysis.cpp
@@ -28,12 +28,13 @@
 
 #include "morphology/Analysis.hpp"
 #include "utils/StringUtils.hpp"
+#include <array>
 
 using namespace libvoikko::utils;
 
 namespace libvoikko { namespace morphology {
 
-static constexpr std::array<const char *,21> KEY_TO_STRING {
+static constexpr std::array<const char *,21> KEY_TO_STRING { {
 	"BASEFORM",
 	"CLASS",
 	"COMPARISON",
@@ -55,7 +56,7 @@ static constexpr std::array<const char *,21> KEY_TO_STRING {
 	"WEIGHT",
 	"WORDBASES",
 	"WORDIDS"
-};
+} };
 
 static const std::map<std::string, Analysis::Key> STRING_TO_KEY = {
 	{"BASEFORM", Analysis::Key::BASEFORM},
