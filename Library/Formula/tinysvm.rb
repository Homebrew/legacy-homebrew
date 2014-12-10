require 'formula'

class Tinysvm < Formula
  homepage 'http://chasen.org/~taku/software/TinySVM/'
  url 'http://chasen.org/~taku/software/TinySVM/src/TinySVM-0.09.tar.gz'
  sha1 '9c3c36454c475180ef6646d059376f35549cad08'

  # Use correct compilation flag
  patch :p0 do
    url "https://trac.macports.org/export/94156/trunk/dports/math/TinySVM/files/patch-configure.diff"
    sha1 "9f59314fa743e98d8fe3e887b58a85f25e4df571"
  end

  def install
    # Needed to select proper getopt, per MacPorts
    ENV.append_to_cflags '-D__GNU_LIBRARY__'

    inreplace 'configure', '-O9', '' # clang barfs on -O9

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-shared"
    system "make install"
  end

  test do
    system "#{bin}/svm_learn", "--help"
    system "#{bin}/svm_classify", "--help"
    system "#{bin}/svm_model", "--help"
  end
end
