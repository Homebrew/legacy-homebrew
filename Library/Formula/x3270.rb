require 'formula'

class X3270 <Formula
  url 'http://sourceforge.net/projects/x3270/files/x3270/3.3.11ga6/suite3270-3.3.11ga6-src.tgz'
  homepage 'http://x3270.bgp.nu/'
  md5 '01d6d3809a457e6f6bd3731642e0c02d'
  version '3.3.11ga6'

  def options
    [
      ["--with-c3270",   "Include c3270 (curses-based version)"],
      ["--with-s3270",   "Include s3270 (displayless version)"],
      ["--with-tcl3270", "Include tcl3270 (integrated with Tcl)"],
      ["--with-pr3287",  "Include pr3287 (printer emulation)"]
    ]
  end

  def install
  	ohai 'x3270'
    Dir.chdir 'x3270-3.3' do
      system "./configure", 	"--prefix=#{prefix}"
      system "make"
      system "make install"
      system "make install.man";
    end
    if ARGV.include? "--with-c3270"
      ohai 'c3270'
      Dir.chdir 'c3270-3.3' do
        system "./configure", 	"--prefix=#{prefix}"
        system "make"
        system "make install"
        system "make install.man";
      end
    end
    if ARGV.include? "--with-pr3287"
      ohai 'pr3287'
      Dir.chdir 'pr3287-3.3' do
        system "./configure", 	"--prefix=#{prefix}"
        system "make"
        system "make install"
        system "make install.man";
      end
    end
    if ARGV.include? "--with-s3270"
      ohai 's3270'
      Dir.chdir 's3270-3.3' do
        system "./configure", 	"--prefix=#{prefix}"
        system "make"
        system "make install"
        system "make install.man";
      end
    end
    if ARGV.include? "--with-tcl3270"
      ohai 'tcl3270'
      Dir.chdir 'tcl3270-3.3' do
        system "./configure", 	"--prefix=#{prefix}"
        system "make"
        system "make install"
        system "make install.man";
      end
    end
  end
end

