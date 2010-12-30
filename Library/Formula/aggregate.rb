require 'formula'

class Aggregate <Formula
  url 'ftp://ftp.isc.org/isc/aggregate/aggregate-1.6.tar.gz'
  md5 '6fcc515388bf2c5b0c8f9f733bfee7e1'

  def install
    inreplace "Makefile.in" do |s|
      s.change_make_var! "CFLAGS", "@CFLAGS@"
      s.change_make_var! "LDFLAGS", ""
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.install "aggregate"
    bin.install "aggregate-ios"
    man1.install "aggregate.1"
    man1.install "aggregate-ios.1"
  end
end
