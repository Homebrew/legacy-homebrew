require 'formula'

class Mpir <Formula
  url 'http://www.mpir.org/mpir-2.1.3.tar.gz'
  homepage 'http://www.mpir.org/'
  md5 'bd7d1d992a6d0a37a0eef84c69839fba'
  head 'http://boxen.math.washington.edu/svn/mpir/mpir/trunk/'

  def options
    [
      ['--enable-gmpcompat',
        "This option allows you to specify that you want additional libraries
        created called libgmp (and libgmpxx), etc., for libraries and gmp.h
        for compatibility with GMP."]
    ]
  end

  def install
    args = [ "--disable-dependency-tracking", "--prefix=#{prefix}" ]
    args << "--enable-gmpcompat" if ARGV.include? '--enable-gmpcompat'
    system "./configure", *args
    system "make"
    system "make install"
  end
end
