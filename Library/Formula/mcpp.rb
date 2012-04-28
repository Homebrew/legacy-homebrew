require 'formula'

class Mcpp < Formula
  url 'http://downloads.sourceforge.net/project/mcpp/mcpp/V.2.7.2/mcpp-2.7.2.tar.gz'
  homepage 'http://mcpp.sourceforge.net/'
  md5 '512de48c87ab023a69250edc7a0c7b05'

  def patches
    # patch to support ZeroC Ice, taken from Ice-3.4.2 third party source archive.
    # http://www.zeroc.com/download.html#src
    #
    # this subsumes the previous patch from this formula
    "https://raw.github.com/gist/f8580f14d689307a2601/8103cf09204859d5ef536a917474391893dcd120/gistfile1.diff"
  end


  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-mcpplib"
    system "make install"
  end

  def test
      # Checks that the output from mcpp -C (with comments) is:
      #
      #   #line 1 "<stdin>"
      #   //comment
      #   test;
      #
      # and not:
      #
      #   #line 1 "<stdin>"
      #   //commenttest;
      #
      system 'echo "test; //comment" | mcpp -C | wc -l | grep -q 3'
  end

end
