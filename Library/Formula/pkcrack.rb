class Pkcrack < Formula
  desc "Implementation of an algorithm for breaking the PkZip cipher"
  homepage "https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack.html"
  url "https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack/pkcrack-1.2.2.tar.gz"
  sha256 "4d2dc193ffa4342ac2ed3a6311fdf770ae6a0771226b3ef453dca8d03e43895a"

  bottle do
    cellar :any
    sha256 "2c71cc20dc2a45a4f4e1077e0036fd524b286dec849af21e36564f4cbe58a2e3" => :yosemite
    sha256 "23f8583cbd6a9caa16e924e87589c268950e5c648777cc5afbebe7b3f40833f8" => :mavericks
    sha256 "b8691b205b39e7849a0b26216973383be28b80c32da766ffc409a5e406ea7340" => :mountain_lion
  end

  # This patch is to build correctly in OSX. I've changed #include<malloc.h> to
  # include<stdlib.h> because OSX doesn't have malloc.h.
  # I have sent to the author [conrad@unix-ag.uni-kl.de] for this patch at 2015/03/31.
  # Detail: https://gist.github.com/jtwp470/e998c720451f8ec849b0
  patch do
    url "https://gist.githubusercontent.com/jtwp470/e998c720451f8ec849b0/raw/012657af1dffd38db4e072a8b793661808a58d69/pkcrack_for_osx_brew.diff"
    sha256 "e0303d9adeffb2fb2a61a82ad040a3fec4edc23cae044ac1517b826c27fce412"
  end

  conflicts_with "libextractor", :because => "both install `extract` binaries"

  def install
    system "make", "-C", "src/"
    bin.install Dir["src/*"].select { |f| File.executable? f }
  end

  test do
    shell_output("pkcrack", 1)
  end
end
