require 'formula'

class Dwarf < Formula
  homepage 'https://code.google.com/p/dwarf-ng/'
  url 'https://dwarf-ng.googlecode.com/files/dwarf-0.3.0.tar.gz'
  sha1 '19a69424bd208741a325a4fc0e791a516c3bc8bc'

  depends_on 'readline'

  # Imports inttypes.h in a generated lex file instead of stdint.h
  # Reported upstream: http://code.autistici.org/trac/dwarf/ticket/8
  # Also has missing & unwanted return values in some functions
  # If the above are fixed, the newer 0.3.1 fails with a missing make target
  fails_with :clang do
    cause "error: unknown type name 'intmax_t'"
  end

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end
end
