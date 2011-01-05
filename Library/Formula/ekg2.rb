require 'formula'

class Ekg2 <Formula
  url 'http://pl.ekg2.org/ekg2-0.3.0_rc5.tar.gz' # latest stable version is from 2007
  homepage 'http://ekg2.org'
  md5 '47007340ec6780dae9682dab21357898'
  version '0.3.0-rc5'

  depends_on 'libgadu' if ARGV.include? "--with-libgadu"
  depends_on 'ncursesw'

  def options
    [
      ["--with-libgadu", "Compiles ekg2 with gadu-gadu support"]
    ]
  end

  # stripping breaks loading shared objects
  skip_clean :all

  def install
    args = ["--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}",
            "--without-python", "--without-perl", "--without-readline",
            "--enable-unicode", "--with-ncurses=#{Formula.factory('ncursesw').prefix}"]

    args << if ARGV.include? "--with-libgadu"
              "--with-libgadu"
            else
              "--without-libgadu"
            end

    system "./configure", *args
    system "make install"
  end
end

