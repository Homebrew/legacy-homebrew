require 'formula'

class Dwarf < Formula
  homepage 'http://code.autistici.org/trac/dwarf'
  url 'http://dwarf-ng.googlecode.com/files/dwarf-0.3.0.tar.gz'
  sha1 '19a69424bd208741a325a4fc0e791a516c3bc8bc'

  head 'http://code.autistici.org/svn/dwarf/trunk'

  depends_on 'readline'

  # There's a subtle error in C99 handling of stdint.h and inttypes.h.
  # Reported upstream: http://code.autistici.org/trac/dwarf/ticket/8
  fails_with :clang do
    build 318
    cause "error: unknown type name 'intmax_t'"
  end

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system "make install"
  end
end
