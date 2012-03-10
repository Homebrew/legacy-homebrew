require 'formula'

class Ecasound < Formula
  url 'http://ecasound.seul.org/download/ecasound-2.8.1.tar.gz'
  homepage 'http://www.eca.cx/ecasound/'
  md5 'd9ded0074a8eeb59dd507c248220d010'

  def options
    [["--with-ruby", "Compile with ruby support."]]
  end

  def install
    args = ["--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--enable-rubyecasound=yes" if ARGV.include?('--with-ruby')
    system "./configure", *args
    system "make install"
  end
end
