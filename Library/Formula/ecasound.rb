require 'formula'

class Ecasound < Formula
  homepage 'http://www.eca.cx/ecasound/'
  url 'http://ecasound.seul.org/download/ecasound-2.9.1.tar.gz'
  sha1 '048fc2487deb3c94d92814b54255435b2acee1d8'

  option "with-ruby", "Compile with ruby support"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << ("--enable-rubyecasound=" + ((build.with? 'ruby') ? 'yes' : 'no'))
    system "./configure", *args
    system "make install"
  end
end
