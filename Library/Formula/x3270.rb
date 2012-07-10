require 'formula'

class X3270 < Formula
  homepage 'http://x3270.bgp.nu/'
  url 'http://sourceforge.net/projects/x3270/files/x3270/3.3.12ga10/suite3270-3.3.12ga10-src.tgz'
  sha1 '582bb7f3f3523e08404cc8eff80860efd7a79e1b'

  def options
    [
      ["--with-c3270",   "Include c3270 (curses-based version)"],
      ["--with-s3270",   "Include s3270 (displayless version)"],
      ["--with-tcl3270", "Include tcl3270 (integrated with Tcl)"],
      ["--with-pr3287",  "Include pr3287 (printer emulation)"]
    ]
  end

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
    make_directory 'c3270-3.3'   if ARGV.include? "--with-c3270"
    make_directory 'pr3287-3.3'  if ARGV.include? "--with-pr3287"
    make_directory 's3270-3.3'   if ARGV.include? "--with-s3270"
    make_directory 'tcl3270-3.3' if ARGV.include? "--with-tcl3270"
  end
end
