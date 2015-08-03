class Cpmtools < Formula
  desc "Tools to access CP/M file systems"
  homepage "http://www.moria.de/~michael/cpmtools/"
  url "http://www.moria.de/~michael/cpmtools/files/cpmtools-2.20.tar.gz"
  sha256 "d8c7e78a9750994124f3aab6e461da8fa0021acc7dbad76eafbac8b0ed8279d3"

  bottle do
    sha1 "a437721156fa15a612e823e4f1ee0fdbfe2d0ed7" => :yosemite
    sha1 "43ea7f0a371628133d4c46e249c32f0a619ad45f" => :mavericks
    sha1 "537d26d243827c8d1506305fce70e9eab7604eaa" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"

    bin.mkpath
    man1.mkpath
    man5.mkpath

    system "make", "install"
  end

  test do
    # make a disk image
    image = testpath/"disk.cpm"
    system "#{bin}/mkfs.cpm -f ibm-3740 #{image}"

    # copy a file into the disk image
    src = testpath/"foo"
    src.write "a" * 128
    system "#{bin}/cpmcp -f ibm-3740 #{image} #{src} 0:foo"

    # check for the file in the cp/m directory
    assert shell_output("#{bin}/cpmls -f ibm-3740 #{image}").include?("foo")

    # copy the file back out of the image
    dest = testpath/"bar"
    system "#{bin}/cpmcp -f ibm-3740 #{image} 0:foo #{dest}"
    assert_equal src.read, dest.read
  end
end
