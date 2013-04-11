require 'formula'

class Scalpel < Formula
  homepage 'http://www.digitalforensicssolutions.com/Scalpel/'
  url 'http://www.digitalforensicssolutions.com/Scalpel/scalpel-2.0.tar.gz'
  sha1 '4cc1164c75471c75f7dfa91c81ccef7eb15142f1'

  depends_on 'tre'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    etc.install "scalpel.conf" => "scalpel.conf.sample"
  end

end
