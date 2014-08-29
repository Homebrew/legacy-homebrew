require 'formula'

class GoogleSparsehash < Formula
  homepage 'http://code.google.com/p/google-sparsehash/'
  url 'https://sparsehash.googlecode.com/files/sparsehash-2.0.2.tar.gz'
  sha1 '12c7552400b3e20464b3362286653fc17366643e'

  option :cxx11

  # Patch from upstream issue: https://code.google.com/p/sparsehash/issues/detail?id=99
  patch do
    url "https://gist.githubusercontent.com/jacknagel/3314c8cc67032a912f8b/raw/387b44a3b46e7b68876dbcb3c6595d700fa08a3c/sparsehash.diff"
    sha1 "bc2083e2c7e699c04f65a1d87dd0cb96deee9b24"
  end

  def install
    ENV.cxx11 if build.cxx11?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make check"
    system "make install"
  end
end
