class Libident < Formula
  desc "Ident protocol library"
  homepage "http://www.remlab.net/libident/"
  url "http://www.remlab.net/files/libident/libident-0.32.tar.gz"
  sha256 "8cc8fb69f1c888be7cffde7f4caeb3dc6cd0abbc475337683a720aa7638a174b"

  bottle do
    cellar :any
    revision 1
    sha1 "64d49643f318b06a290951083fe02e28956288dc" => :yosemite
    sha1 "2d309cbd2783f327c92ff5ea640e052059bb6d43" => :mavericks
    sha1 "e449ccd40b06a2b32cc1c36d076354a5402e7df3" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
