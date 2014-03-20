require 'formula'

class Cksfv < Formula
  homepage 'http://zakalwe.fi/~shd/foss/cksfv/'
  url 'http://zakalwe.fi/~shd/foss/cksfv/files/cksfv-1.3.14.tar.bz2'
  sha1 'f6da3a559b2862691a2be6d2be0aac66cd624885'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    path = testpath/"foo"
    path.write "abcd"

    lines = `#{bin}/cksfv #{path}`.split("\n")
    assert lines.include?("#{path} ED82CD11")
    assert_equal 0, $?.exitstatus
  end
end
