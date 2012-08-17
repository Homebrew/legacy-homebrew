require 'formula'

class Tophat < Formula
  url 'http://tophat.cbcb.umd.edu/downloads/tophat-1.4.1.tar.gz'
  homepage 'http://tophat.cbcb.umd.edu/'
  md5 '73f7c3b6b2f68f291757026c38eab551'

  depends_on 'samtools'

  fails_with :clang do
    build 421
    cause <<-EOS.undent
      Compiling with clang results in the error "default arguments
      cannot be added to a function template that has already been declared".
      Upstream source should move default parameter declaration to fix.
    EOS
  end

  def install
    # It seems this project Makefile doesn't like -j4
    # Disable until consult with upstream
    ENV.deparallelize

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
