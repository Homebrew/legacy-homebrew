class Libident < Formula
  desc "Ident protocol library"
  homepage "http://www.remlab.net/libident/"
  url "http://www.remlab.net/files/libident/libident-0.32.tar.gz"
  sha256 "8cc8fb69f1c888be7cffde7f4caeb3dc6cd0abbc475337683a720aa7638a174b"

  bottle do
    cellar :any
    revision 1
    sha256 "53db8e889d8efa34b4a3b6a145bcec2bcb53595e7db0cfdd55c8d857dff3a442" => :yosemite
    sha256 "d8e20cc9d2015b83785d4eb05110afc082a6389267df82546cc89e693dd2db6a" => :mavericks
    sha256 "0bb13ba0c69e3bcf77da2edaac0b500c074724a7a191674bc2914525dbf7dcd0" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
