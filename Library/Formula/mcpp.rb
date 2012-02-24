require 'formula'

class Mcpp < Formula
  url 'http://downloads.sourceforge.net/project/mcpp/mcpp/V.2.7.2/mcpp-2.7.2.tar.gz'
  homepage 'http://mcpp.sourceforge.net/'
  md5 '512de48c87ab023a69250edc7a0c7b05'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-mcpplib"
    system "make install"
  end

  def patches
    "https://gist.github.com/raw/668341/e50827c8d9e8452befcab64bd8800b16d1f66d0e/mcpp-fix-stpcpy.patch"
    "https://raw.github.com/gist/1899036/960203cf482f1cde771c09ccd78ba91069ab9162/patch.mcpp.2.7.2"
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
