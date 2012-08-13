require 'formula'

class Bigloo < Formula
  url 'ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo3.8c.tar.gz'
  version '3.8c'
  homepage 'http://www-sop.inria.fr/indes/fp/Bigloo/'
  sha1 'e876e3f8dc5315aa61177721695e9c04b19f25d9'

  # libgmp seems to be required for 32-bit srfi 27 only, but include anyway
  depends_on 'gmp'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      objs/obj_u/Ieee/dtoa.c:262:79504: fatal error: parser
      recursion limit reached, program too complex
      EOS
  end

  def install
    args = [ "--disable-debug", "--disable-dependency-tracking",
             "--prefix=#{prefix}",
             "--mandir=#{man1}", # This is correct for this brew
             "--infodir=#{info}",
             "--customgc=yes",
             "--os-macosx" ]

    # SRFI 27 is 32-bit only
    args << "--disable-srfi27" if MacOS.prefer_64_bit?

    system "./configure", *args
    system "make"
    system "make install"

    # Install the other manpages too
    manpages = %w( bgldepend bglmake bglpp bgltags bglafile bgljfile bglmco bglprof )
    manpages.each {|m| man1.install "manuals/#{m}.man" => "#{m}.1"}
  end
end
