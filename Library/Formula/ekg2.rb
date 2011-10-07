require 'formula'

def use_libgadu?; ARGV.include? "--with-libgadu"; end

class Ekg2 < Formula
  url 'http://pl.ekg2.org/ekg2-0.3.1.tar.gz'
  homepage 'http://ekg2.org'
  md5 '68fc05b432c34622df6561eaabef5a40'

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'libgadu' if use_libgadu?

  # stripping breaks loading shared objects
  skip_clean :all

  def options
    [["--with-libgadu", "Compiles ekg2 with gadu-gadu support"]]
  end

  def install
    readline = Formula.factory 'readline'

    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--without-python",
            "--without-perl",
            "--with-readline=#{readline.prefix}",
            "--without-gtk",
            "--enable-unicode"]

    args << use_libgadu? ? "--with-libgadu" : "--without-libgadu"

    system "./configure", *args
    system "make install"
  end
end

