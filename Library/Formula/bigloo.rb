require 'formula'

class Bigloo < Formula
  homepage 'http://www-sop.inria.fr/indes/fp/Bigloo/'
  url 'ftp://ftp-sop.inria.fr/indes/fp/Bigloo/bigloo4.0a.tar.gz'
  version '4.0a'
  sha1 '63e0e363a7900d9e7d02f63c50ba2079053ef2d1'

  depends_on 'gmp'

  option 'with-jvm', 'Enable JVM support'

  fails_with :clang do
    build 425
    cause <<-EOS.undent
      objs/obj_u/Ieee/dtoa.c:262:79504: fatal error: parser
      recursion limit reached, program too complex
      EOS
  end

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--mandir=#{man1}",
            "--infodir=#{info}",
            "--customgc=yes",
            "--os-macosx",
            "--native=yes",
            "--disable-alsa",
            "--disable-mpg123",
            "--disable-flac"]

    args << "--jvm=yes" if build.include? 'with-jvm'

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
