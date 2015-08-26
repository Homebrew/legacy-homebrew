class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "http://www.caida.org/tools/measurement/scamper/"
  url "http://www.caida.org/tools/measurement/scamper/code/scamper-cvs-20141101.tar.gz"
  sha256 "aae527dbbc827b735196e0bee47518daad4583cd1feda367442ad43252fd7278"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
