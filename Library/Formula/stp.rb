require 'formula'

class Stp < Formula
  head 'http://stp-fast-prover.svn.sourceforge.net/svnroot/stp-fast-prover/trunk/stp', :revision => '1028'
  homepage 'http://sites.google.com/site/stpfastprover/'

  def options
    [["--32-bit", "Force 32-bit."]]
  end

  def install
    unless ARGV.include? "--32-bit"
      inreplace "./scripts/Makefile.common" do |s|
        s.remove_make_var! "CFLAGS_M32"
      end
    end

    system "./scripts/configure", "--with-prefix=#{prefix}"
    system "make install"
  end
end
