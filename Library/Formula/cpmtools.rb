require 'formula'

class Cpmtools < Formula
  homepage 'http://www.moria.de/~michael/cpmtools/'
  url 'http://www.moria.de/~michael/cpmtools/cpmtools-2.17.tar.gz'
  sha1 '71e9d3a7de4b366a52ac24e53c2958c2b8124e5f'

  def install
    system "./configure", "--prefix=#{prefix}"

    bin.mkpath
    man1.mkpath
    man5.mkpath

    system "make install"
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
    assert `#{bin}/cpmls -f ibm-3740 #{image}`.include?("foo")
    assert_equal 0, $?.exitstatus

    # copy the file back out of the image
    dest = testpath/"bar"
    system "#{bin}/cpmcp -f ibm-3740 #{image} 0:foo #{dest}"
    assert_equal src.read, dest.read
  end
end
