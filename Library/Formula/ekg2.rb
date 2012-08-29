require 'formula'

class Ekg2 < Formula
  homepage 'http://ekg2.org'
  url 'http://pl.ekg2.org/ekg2-0.3.1.tar.gz'
  md5 '68fc05b432c34622df6561eaabef5a40'

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'libgadu' if build.include? "with-libgadu"

  # stripping breaks loading shared objects
  skip_clean :all

  option "with-libgadu", "Compiles ekg2 with gadu-gadu support"

  def install
    readline = Formula.factory 'readline'

    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--without-python",
            "--without-perl",
            "--with-readline=#{readline.prefix}",
            "--without-gtk",
            "--enable-unicode"]

    args << build.include?("with-libgadu") ? "--with-libgadu" : "--without-libgadu"

    system "./configure", *args
    system "make install"
  end
end

