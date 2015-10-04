class Fsh < Formula
  desc "Provides remote command execution"
  homepage "https://www.lysator.liu.se/fsh/"
  url "https://www.lysator.liu.se/fsh/fsh-1.2.tar.gz"
  sha256 "9600882648966272c264cf3f1c41c11c91e704f473af43d8d4e0ac5850298826"

  bottle do
    cellar :any
    sha1 "0032ffd126903008825b9f3d1d7a6a261da8411e" => :yosemite
    sha1 "fa0639c0b04a59327078f3c56fd416530ecf48ee" => :mavericks
    sha1 "4cb087d1b5b153e22cf726c6e986615620551273" => :mountain_lion
  end

  def install
    # FCNTL was deprecated and needs to be changed to fcntl
    inreplace "fshcompat.py", "FCNTL", "fcntl"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}"
    system "make", "install"
  end

  test do
    system "fsh", "-V"
  end
end
