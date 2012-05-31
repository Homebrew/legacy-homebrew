require 'formula'

class Ann < Formula
  homepage 'http://www.cs.umd.edu/~mount/ANN/'
  url 'http://www.cs.umd.edu/~mount/ANN/Files/1.1.2/ann_1.1.2.zip'
  md5 '31267ffbe4e6d04768b3ec21763e9343'

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
