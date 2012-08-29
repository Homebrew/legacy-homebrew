require 'formula'

# 2.9.0 is out, but uses clock_gettime which is not available on OS X
class Ecasound < Formula
  homepage 'http://www.eca.cx/ecasound/'
  url 'http://ecasound.seul.org/download/ecasound-2.8.1.tar.gz'
  md5 'd9ded0074a8eeb59dd507c248220d010'

  option "with-ruby", "Compile with ruby support"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--enable-rubyecasound=yes" if build.include? 'with-ruby'
    system "./configure", *args
    system "make install"
  end
end
