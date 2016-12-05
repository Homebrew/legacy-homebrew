class GneuralNetwork < Formula
  desc "Programmable neural network."
  homepage "https://www.gnu.org/software/gneuralnetwork/"
  url "http://cvs.savannah.gnu.org/viewvc/*checkout*/gneuralnetwork/gneural_network-0.5.0.tar.gz?revision=1.1&root=gneuralnetwork"
  version "0.5.0"
  sha256 "7bfff0cc3e4a1fd7ffa18c5c2476bd6d93ffb0a14b50c7feda9312bea943cf9f"

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal shell_output("#{bin}/gneural_network --help").strip,
                 "Gneural Network"
  end
end
