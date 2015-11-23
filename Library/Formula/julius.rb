class Julius < Formula
  desc "Two-pass large vocabulary continuous speech recognition engine"
  homepage "https://julius.osdn.jp"
  url "http://dl.osdn.jp/julius/60273/julius-4.3.1.tar.gz"
  sha256 "4bf77c7b91f4bb0686c375c70bd4f2077e7de7db44f60716af9f3660f65a6253"

  bottle do
    cellar :any
    sha256 "42b7494d1a3f3d74cef3363a329c93df0cfb5903399193892c5834a7d482c394" => :yosemite
    sha256 "e4cdb2839882a69a95e9136e232e616e8e4ee20766dbb7ed480cde333ba50527" => :mavericks
    sha256 "14c430143ee00b9981e39e91450be1c2442636b4f37d9c51e432d3377f747449" => :mountain_lion
  end

  depends_on "libsndfile"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/julius.dSYM --help", 1)
  end
end
