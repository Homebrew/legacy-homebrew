require 'brewkit'

class Mpg123 <Formula
  @url='http://sourceforge.net/projects/mpg123/files/mpg123/mpg123-1.8.1.tar.bz2'
  @homepage='http://www.mpg123.de/'
  @md5='856893f14b29b1cddf4aba32469860b4'

  def skip_clean? path
    # mpg123 can't find its plugins if there are no la files
    path.extname == '.la'
  end

  def install
    if MACOS_VERSION < 10.6
      # otherwise the exe segfaults, I couldn't diagnose why
      ENV.osx_10_4
      ENV.gcc_4_0_1
    end

    args = ["--disable-debug", "--with-optimization=4",
                               "--with-cpu=sse_alone",
                               "--prefix=#{prefix}"]

    args << "--with-cpu=x86-64" if Hardware.is_64_bit?

    system "./configure", *args
    system "make install"
  end
end