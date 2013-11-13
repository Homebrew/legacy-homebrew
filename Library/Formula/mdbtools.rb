require 'formula'

class Mdbtools < Formula
  homepage 'https://github.com/brianb/mdbtools/'
  url "https://github.com/brianb/mdbtools/archive/0.7.1.tar.gz"
  sha1 '33b746f29c1308909a1e82546ec24e8f835d461a'

  option 'with-man-pages', 'Build manual pages'

  depends_on 'pkg-config' => :build
  depends_on 'txt2man' => :build if build.include? 'with-man-pages'
  depends_on 'glib'
  depends_on 'readline'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  def install
    ENV.deparallelize

    args = ["--prefix=#{prefix}"]
    args << "--disable-man" unless build.include? 'with-man-pages'

    if MacOS.version == :snow_leopard
      # aclocal does not respect ACLOCAL_PATH on 10.6
      ENV['ACLOCAL'] = 'aclocal ' + ENV['ACLOCAL_PATH'].split(':').map {|p| '-I' + p}.join(' ')
      mkdir "build-aux"
      touch "build-aux/config.rpath"
      # AM_PROG_AR does not exist in 10.6 automake
      inreplace 'configure.ac', 'AM_PROG_AR', 'm4_ifdef([AM_PROG_AR], [AM_PROG_AR])'
    end

    system "autoreconf", "-i", "-f"
    system "./configure", *args
    system "make install"
  end
end
