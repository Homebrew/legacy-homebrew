class Dwarf < Formula
  desc "Object file manipulation tool"
  homepage "https://code.google.com/p/dwarf-ng/"
  url "https://dwarf-ng.googlecode.com/files/dwarf-0.3.0.tar.gz"
  sha256 "85062d0d3e8aa31374dd085cb79ce02c2b8737e9b143f640a262556233715763"

  depends_on "readline"

  # Imports inttypes.h in a generated lex file instead of stdint.h
  # Reported upstream: http://code.autistici.org/trac/dwarf/ticket/8
  # Also has missing & unwanted return values in some functions
  # If the above are fixed, the newer 0.3.1 fails with a missing make target
  fails_with :clang do
    cause "error: unknown type name 'intmax_t'"
  end

  # /usr/include/inttypes.h:256:8: error: unknown type name 'uintmax_t'
  # https://github.com/elboza/dwarf-ng/issues/1
  fails_with :gcc => "5"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dwarf --help", 1)
  end
end
