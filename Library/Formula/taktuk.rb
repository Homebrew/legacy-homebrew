class Taktuk < Formula
  desc "Deploy commands to (a potentially large set of) remote nodes"
  homepage "http://taktuk.gforge.inria.fr/"
  url "http://gforge.inria.fr/frs/download.php/30903/taktuk-3.7.5.tar.gz"
  sha256 "62d1b72616a1b260eb87cecde2e21c8cbb844939f2dcafad33507fcb16ef1cb1"

  bottle do
    sha1 "10148b0847e2a3472f64f6895bb3bd776ed5f974" => :yosemite
    sha1 "8a666343a2d60bec377fdcada04799762bf78beb" => :mavericks
    sha1 "e0a75b88757ebfd266efe87a2d001bfd3cdde224" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make", "install"
  end

  test do
    system "#{bin}/taktuk", "quit"
  end
end
