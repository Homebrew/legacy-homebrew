class Libosip < Formula
  desc "Implementation of the eXosip2 stack"
  homepage "https://www.gnu.org/software/osip/"
  url "http://ftpmirror.gnu.org/osip/libosip2-4.1.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/osip/libosip2-4.1.0.tar.gz"
  sha256 "996aa0363316a871915b6f12562af53853a9962bb93f6abe1ae69f8de7008504"

  bottle do
    cellar :any
    revision 2
    sha256 "87803e02c0c3b65c8f028864200425f90b5a708bb6204a410f6c76a9e35545ee" => :yosemite
    sha256 "531e7d5fb51ec0ccdc05b3e3346710770f756fa8b3eb7eb2cbbbe5b2cb1c8d59" => :mavericks
    sha256 "c9424adf4a5eae16c98276e958650cadb419b54b0c3b420a7d81006d423ea2f7" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
