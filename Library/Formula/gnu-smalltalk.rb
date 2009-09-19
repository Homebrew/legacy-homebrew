require 'brewkit'

class GnuSmalltalk <Formula
  @url='ftp://ftp.gnu.org/gnu/smalltalk/smalltalk-3.1.tar.gz'
  @homepage='http://smalltalk.gnu.org/'
  @md5='fb4630a86fc47c893cf9eb9adccd4851'

  def patches
    {
      :p1 => ["http://bitbucket.org/0xffea/patches/raw/bc22b0b12337/homebrew/smalltalk-001-install.diff"]
    }
  end

  def install
    ENV['FFI_CFLAGS'] = '-I/usr/include/ffi'
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--with-readline=/usr/lib"
    system "make install"
  end
end
