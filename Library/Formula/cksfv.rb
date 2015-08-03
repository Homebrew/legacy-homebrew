class Cksfv < Formula
  desc "File verification utility"
  homepage "http://zakalwe.fi/~shd/foss/cksfv/"
  url "http://zakalwe.fi/~shd/foss/cksfv/files/cksfv-1.3.14.tar.bz2"
  sha256 "8f3c246f3a4a1f0136842a2108568297e66e92f5996e0945d186c27bca07df52"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"foo"
    path.write "abcd"

    assert shell_output("#{bin}/cksfv #{path}").include?("#{path} ED82CD11")
  end
end
