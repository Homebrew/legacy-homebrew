class Pwgen < Formula
  desc "Password generator"
  homepage "http://pwgen.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pwgen/pwgen/2.07/pwgen-2.07.tar.gz"
  sha1 "51180f9cd5530d79eea18b2443780dec4ec5ea43"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end

  test do
    system "#{bin}/pwgen", "--secure", "20", "10"
  end
end
