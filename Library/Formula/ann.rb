require 'formula'

class Ann < Formula
  url 'http://www.cs.umd.edu/~mount/ANN/Files/1.1.2/ann_1.1.2.zip'
  homepage 'http://www.cs.umd.edu/~mount/ANN/'
  md5 '31267ffbe4e6d04768b3ec21763e9343'

  def install
    system "make", "macosx-g++"
    bin.install Dir["bin/*"]
    prefix.install ["lib","sample","doc","include"]
  end

  def test
    system "#{bin}/ann_sample", "-df", "#{prefix}/sample/data.pts", "-qf", "query.pts"
  end
end
