require 'formula'

class Sigar < Formula
  # HEAD has up to date bindings that are actually useful.
  head 'https://github.com/hyperic/sigar.git'
  homepage 'http://sigar.hyperic.com/'

  option "perl", "Build Perl bindings"
  option "python", "Build Python bindings"
  option "ruby", "Build Ruby bindings"

  def java_script; <<-EOS.undent
    #!/bin/sh
    # Runs SIGAR's REPL.
    java -jar #{prefix}/sigar.jar
    EOS
  end

  def install
    # Build Java JAR & C library first.
    cd "bindings/java" do
      system "ant"

      cd "sigar-bin/lib" do
        prefix.install 'sigar.jar'
        lib.install Dir['*.dylib']
      end

      include.install Dir['sigar-bin/include/*']

      (bin/'sigar').write java_script
    end

    # Install Python bindings
    cd "bindings/python" do
      system "python", "setup.py", "install", "--prefix=#{prefix}"
    end if build.include? "python"

    # Install Perl bindings
    cd "bindings/perl" do

      system "perl", "Makefile.PL"

      # Tweak the Makefile to install.
      # Can't pass PREFIX, as the Sigar build system uses ARGV[0]
      inreplace "Makefile" do |s|
        s.change_make_var! 'PREFIX', prefix
        s.change_make_var! 'PERLPREFIX', '$(PREFIX)'
        s.change_make_var! 'SITEPREFIX', '$(PREFIX)'
        s.change_make_var! 'VENDORPREFIX', '$(PREFIX)'
        s.change_make_var! 'INSTALLPRIVLIB', "$(PERLPREFIX)\\1"
        s.change_make_var! 'INSTALLSITELIB', "$(PERLPREFIX)\\1"
        s.change_make_var! 'INSTALLVENDORLIB', "$(PERLPREFIX)\\1"
        s.change_make_var! 'INSTALLARCHLIB', "$(PERLPREFIX)\\1"
        s.change_make_var! 'INSTALLSITEARCH', "$(PERLPREFIX)\\1"
        s.change_make_var! 'INSTALLVENDORARCH', "$(PERLPREFIX)\\1"
      end

      system "make install"
    end if build.include? "perl"

    # Install Ruby bindings
    cd "bindings/ruby" do
      system "ruby", "extconf.rb", "--prefix=#{prefix}"
      system "make install"
    end if build.include? "ruby"
  end
end
