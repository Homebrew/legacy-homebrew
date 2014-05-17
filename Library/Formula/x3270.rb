require 'formula'

class X3270 < Formula
  homepage 'http://x3270.bgp.nu/'
  url 'https://downloads.sourceforge.net/project/x3270/x3270/3.3.14ga9/suite3270-3.3.14ga9-src.tgz'
  sha1 '84ccfd84b451adf70e38903dd20850c87832b1da'

  bottle do
    sha1 "53572df34392b38370ef321337ce2741f8c7ca74" => :mavericks
    sha1 "d188824a9400f7b551b1100fd9f43a1831d2aeb6" => :mountain_lion
    sha1 "4d9dcfe825e75c093e0da6e00594d107d92c6086" => :lion
  end

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
    make_directory 'c3270-3.3' if build.with? "c3270"
    make_directory 'pr3287-3.3' if build.with? "pr3287"
    make_directory 's3270-3.3' if build.with? "s3270"
    make_directory 'tcl3270-3.3' if build.with? "tcl3270"
  end
end
