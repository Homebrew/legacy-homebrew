require 'formula'

class Ann < Formula
  homepage 'http://www.cs.umd.edu/~mount/ANN/'
  url 'http://www.cs.umd.edu/~mount/ANN/Files/1.1.2/ann_1.1.2.zip'
  sha1 '622be90314a603ef9b2abadcf62379f73f28f46c'

  def install
    system "make", "macosx-g++"
    prefix.install "bin", "lib", "sample", "doc", "include"
  end

  def test
    cd "#{prefix}/sample" do
      system "#{bin}/ann_sample", "-df", "data.pts", "-qf", "query.pts"
    end
  end
end
