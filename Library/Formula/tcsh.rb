require "formula"

class Tcsh < Formula
  homepage 'http://www.tcsh.org/'
  url 'ftp://ftp.astron.com/pub/tcsh/tcsh-6.18.01.tar.gz'
  sha1 'eee2035645737197ff8059c84933a75d23cd76f9'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/'test.csh').write <<-EOS.undent
      #!#{bin}/tcsh
      set ARRAY=( "t" "e" "s" "t" )
      foreach i ( `seq $#ARRAY` )
        echo -n $ARRAY[$i]
      end
    EOS
    assert_equal "test", `#{bin}/tcsh ./test.csh`
  end
end
