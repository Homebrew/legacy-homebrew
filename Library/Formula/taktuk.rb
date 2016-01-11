class Taktuk < Formula
  desc "Deploy commands to (a potentially large set of) remote nodes"
  homepage "http://taktuk.gforge.inria.fr/"
  url "https://gforge.inria.fr/frs/download.php/30903/taktuk-3.7.5.tar.gz"
  sha256 "62d1b72616a1b260eb87cecde2e21c8cbb844939f2dcafad33507fcb16ef1cb1"

  bottle do
    sha256 "ffff7a3c68049d0b5918dce6eff6230c239b0845a4b62a5df247e92e09217823" => :yosemite
    sha256 "f87e8447c70bbbdb9419c9735adab38e4bb5e5191d227e70b387c10cbfcc0de6" => :mavericks
    sha256 "061d1c9e324e5b73bcf79e9e6df97de5aef12a8e52ff36348506fa49681f7431" => :mountain_lion
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
