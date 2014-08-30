require 'formula'

class Autogen < Formula
  homepage 'http://autogen.sourceforge.net'
  url 'http://ftpmirror.gnu.org/autogen/rel5.18.2/autogen-5.18.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/autogen/rel5.18.2/autogen-5.18.2.tar.gz'
  sha1 'c63a0f567b4ad90c4243efbd2420c51e6b63309a'

  bottle do
    sha1 "f0f73e326bc3f93b8e9095ed79a7baa50ca2e9b7" => :mavericks
    sha1 "a4e6e9f7f9b60d18fd43b29c88a857dbab8b3b60" => :mountain_lion
    sha1 "729f19be0284020f55ebc5b343a9811cde92630c" => :lion
  end

  # Please note, 5.18.2 is not the newest Autogen package.
  # However, 5.18.3 has an unresolved guile issue and should not be updated to.
  # Please do not submit an update to 5.18.3 until this issue (https://github.com/Homebrew/homebrew/pull/30406) is resolved.
  # The ongoing 5.18.3 guile issue has been reported upstream to Autogen's devs.

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
