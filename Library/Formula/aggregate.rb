require 'formula'

class Aggregate <Formula
  url 'ftp://ftp.isc.org/isc/aggregate/aggregate-1.6.tar.gz'
  homepage 'http://freshmeat.net/projects/aggregate/'
  md5 '6fcc515388bf2c5b0c8f9f733bfee7e1'

  def install
    inreplace "Makefile.in" do |s|
      s.change_make_var! "CFLAGS", "@CFLAGS@"
      s.change_make_var! "LDFLAGS", ""
      s.gsub! "$(prefix)/man/man1", "$(prefix)/share/man/man1"
    end
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    man1.mkpath
    system "make install"
  end
end
