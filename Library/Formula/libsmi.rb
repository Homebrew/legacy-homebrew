require 'formula'

class Libsmi < Formula
  homepage 'http://www.ibr.cs.tu-bs.de/projects/libsmi/'
  url 'https://www.ibr.cs.tu-bs.de/projects/libsmi/download/libsmi-0.4.8.tar.gz'
  sha1 '77c512ccbdd29667d152398b0dcde533aed57b49'

  bottle do
    revision 1
    sha1 "926dcdef0a96a52898ef1848c621bb261ea96330" => :yosemite
    sha1 "545b6b13369663d040e377380a1363a6fe79527a" => :mavericks
    sha1 "a51083176c16132820ed4cdd2a68666baba11ff1" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
