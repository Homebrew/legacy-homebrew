require 'formula'

class PcscTools < Formula
  url 'http://ludovic.rousseau.free.fr/softwares/pcsc-tools/pcsc-tools-1.4.18.tar.gz'
  homepage 'http://ludovic.rousseau.free.fr/softwares/pcsc-tools/'
  md5 '647ec2779cec69c910906fe5496f4e6c'

  def install
    # This package doesn't have a configure script, just a Makefile.
    # To override the default settings we need this:
    ENV['DESTDIR'] = "#{prefix}"
    ENV['PCSC_CFLAGS'] = ""
    ENV['PCSC_LDLIBS'] = "-framework PCSC"
    
    system "make install"
  end

  def test
    system "pcsc_scan -V"
  end
  
  def caveats
    <<-EOS.undent
      Homebrew has NOT installed the CPAN module Chipcard::PCSC::Card. We recommend the following method of
      installation:
        sudo cpan -i Chipcard::PCSC::Card
      After installing this, pcsc_scan and scriptor should work.
        
      For gscriptor you would need the CPAN modules Glib and Gtk2:
        sudo cpan -i Glib
      This fails on Mac OS X 10.7.2 as the dependency 'Cairo' fails to build.
    EOS
  end
  
end