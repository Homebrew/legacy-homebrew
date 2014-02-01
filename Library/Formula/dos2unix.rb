require 'formula'

class Dos2unix < Formula
  homepage 'http://waterlan.home.xs4all.nl/dos2unix.html'
  url 'http://waterlan.home.xs4all.nl/dos2unix/dos2unix-6.0.4.tar.gz'
  sha1 '93d73148c09908a42dcbf5339312c9aa1f18ba7c'

  depends_on 'gettext'

  devel do
    url 'http://waterlan.home.xs4all.nl/dos2unix/dos2unix-6.0.5-beta3.tar.gz'
    sha1 '5b6c6d5f6094ede4a6788a109febf6e15d47d42b'
  end

  def install
    gettext = Formula.factory("gettext")
    system "make", "prefix=#{prefix}",
                   "CC=#{ENV.cc}",
                   "CPP=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "CFLAGS_OS=-I#{gettext.include}",
                   "LDFLAGS_EXTRA=-L#{gettext.lib} -lintl",
                   "install"
  end

  test do
    (testpath/'dosfile.txt').write("File with CRLFs\r\nThey will be converted")
    system "#{bin}/dos2unix", 'dosfile.txt'
    open('dosfile.txt') do |f|
      converted = f.read(64)
      fail if converted.include?("\r")
    end
  end
end
