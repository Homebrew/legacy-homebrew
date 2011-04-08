require 'formula'

class Bigloo < Formula
  url 'ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo3.4a-3.tar.gz'
  version '3.4a-3'
  homepage 'http://www-sop.inria.fr/indes/fp/Bigloo/'
  md5 '1e6589bdf1c974fe2b992457bb3ce321'

  # libgmp seems to be required for 32-bit srfi 27 only, but include anyway
  depends_on 'gmp'

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
