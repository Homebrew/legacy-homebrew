require 'formula'

class Halibut < Formula
  homepage 'http://www.chiark.greenend.org.uk/~sgtatham/halibut/'
  url 'http://www.chiark.greenend.org.uk/~sgtatham/halibut/halibut-1.0.tar.gz'
  sha1 '1e4643faf2bb4e1843740b8c70635d3d33bb7989'

  def install
    ENV.deparallelize

    mkdir_p "#{bin}"
    mkdir_p "#{man1}"

    system "make", "prefix=#{prefix}", "mandir=#{man}", "all"
    cd "doc/" do
      system "make", "prefix=#{prefix}", "mandir=#{man}"
    end
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end

  test do
    system "#{bin}/halibut", "--version"
  end
end
