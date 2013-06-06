require 'formula'

class X3270 < Formula
  homepage 'http://x3270.bgp.nu/'
  url 'http://sourceforge.net/projects/x3270/files/x3270/3.3.12ga13/suite3270-3.3.12ga13-src.tgz'
  sha1 '4c031a7da1d13550ec85726846e31c34d819f971'

  depends_on :x11

  option 'with-c3270', 'Include c3270 (curses-based version)'
  option 'with-s3270', 'Include s3270 (displayless version)'
  option 'with-tcl3270', 'Include tcl3270 (integrated with Tcl)'
  option 'with-pr3287', 'Include pr3287 (printer emulation)'

  def make_directory(directory)
    cd directory do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make install"
      system "make install.man"
    end
  end

  def install
    make_directory 'x3270-3.3'
    make_directory 'c3270-3.3' if build.include? "with-c3270"
    make_directory 'pr3287-3.3' if build.include? "with-pr3287"
    make_directory 's3270-3.3' if build.include? "with-s3270"
    make_directory 'tcl3270-3.3' if build.include? "with-tcl3270"
  end
end
