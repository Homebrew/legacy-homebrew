require 'formula'

class Autogen < Formula
  homepage 'http://autogen.sourceforge.net'
  url 'http://ftpmirror.gnu.org/autogen/rel5.18.1/autogen-5.18.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/autogen/rel5.18.1/autogen-5.18.1.tar.gz'
  sha1 '53d29cafd187895f795e2ba94b9964f71da93060'

  depends_on 'guile'

  fails_with :clang do
    build 500
    cause <<-EOS.undent
      Clang does not appear to be able to handle variables using the name
      'noreturn' as it is a new keyword in C++11, but it would normally be
      used as in [[noreturn]] void foo() and not as a variable name. I'm not
      sure if this is a compiler bug or what, but GCC handles it fine at
      the moment.
    EOS
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # make and install must be separate steps for this formula
    system "make"
    system "make install"
  end
end
