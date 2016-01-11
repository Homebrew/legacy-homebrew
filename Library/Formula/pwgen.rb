class Pwgen < Formula
  desc "Password generator"
  homepage "http://pwgen.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pwgen/pwgen/2.07/pwgen-2.07.tar.gz"
  sha256 "eb74593f58296c21c71cd07933e070492e9222b79cedf81d1a02ce09c0e11556"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/pwgen", "--secure", "20", "10"
  end
end
