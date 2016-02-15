class Fprobe < Formula
  desc "Libpcap-based NetFlow probe"
  homepage "https://sourceforge.net/projects/fprobe/"
  url "https://downloads.sourceforge.net/project/fprobe/fprobe/1.1/fprobe-1.1.tar.bz2"
  sha256 "3a1cedf5e7b0d36c648aa90914fa71a158c6743ecf74a38f4850afbac57d22a0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b06507a358024842b59c9f4d637b94b3681e720dbd3a1a8bc93d4d34f9a4442" => :el_capitan
    sha256 "18043cf3fcc930ee1690ee4bc74d92eed3c56a2424f85d58720c56a4b5bcad1d" => :yosemite
    sha256 "71b149edc078b237aecde23a53d76dc9809e3c9efafb32b52c03f3cc4af91c36" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /NetFlow/, shell_output("#{sbin}/fprobe -h").strip
  end
end
