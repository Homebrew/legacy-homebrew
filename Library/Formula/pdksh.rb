class Pdksh < Formula
  desc "Public domain version of the Korn shell"
  homepage "http://www.cs.mun.ca/~michael/pdksh/"
  url "http://www.cs.mun.ca/~michael/pdksh/files/pdksh-5.2.14.tar.gz"
  sha256 "ab15bcdd50f291edc632bca351b2edce5405d4f2ce3854d3d548d721ab9bbfa6"

  bottle do
    cellar :any
    sha256 "f1f4aab0c6110d5b30050fc0ed5e4660a4adf5e2364d0622b1872795b39b1417" => :yosemite
    sha256 "fa0b42b6f6aea018b537301b38151d6a3e20f8b8d694c5f768bab1d0d64a5b35" => :mavericks
    sha256 "29bcb04237c4a30870c028220d6284303d85e55eaab91fd5a5b3ea47915e9785" => :mountain_lion
  end

  patch :p2 do # Upstream patches
    url "http://www.cs.mun.ca/~michael/pdksh/files/pdksh-5.2.14-patches.1"
    sha256 "b4adfc47e4d78eb8718ee10f7ffafc218b0e9d453413456fab263985ae02d356"
  end

  patch :p0 do
    url "http://www.cs.mun.ca/~michael/pdksh/files/pdksh-5.2.14-patches.2"
    sha256 "82041113e0b3aeca57bb9b161257b43d9f8eba95fd450d2287666e77e6209afd"
  end

  patch :p0 do # Use `sort -k 3n -k 1` instead of `sort +2n +0n`, via MacPorts.
    url "https://raw.githubusercontent.com/Homebrew/patches/af7a9de9/pdksh/patch-siglist.sh"
    sha256 "23a3b4cbf67886c358a26818a95f9b39304d0aab82dead78d5438b633a0917bc"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--program-prefix=pd"
    system "make", "install"

    share.install prefix/"man" # Avoid an inreplace this way.
    prefix.install buildpath/"etc"
  end

  test do
    assert_equal "Hello World!", pipe_output("#{bin}/pdksh -c 'echo Hello World!'").chomp
  end
end
