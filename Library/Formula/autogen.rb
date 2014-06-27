require 'formula'

class Autogen < Formula
  homepage 'http://autogen.sourceforge.net'
  url 'http://ftpmirror.gnu.org/autogen/rel5.18.2/autogen-5.18.2.tar.gz'
  mirror 'http://ftp.gnu.org/pub/gnu/autogen/rel5.18.2/autogen-5.18.2.tar.gz'
  sha1 'c63a0f567b4ad90c4243efbd2420c51e6b63309a'

  depends_on 'guile'
  depends_on 'pkg-config' => :build

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
