class Libcsv < Formula
  desc "CSV library in ANSI C89"
  homepage "https://sourceforge.net/projects/libcsv/"
  url "https://downloads.sourceforge.net/project/libcsv/libcsv/libcsv-3.0.3/libcsv-3.0.3.tar.gz"
  sha256 "d9c0431cb803ceb9896ce74f683e6e5a0954e96ae1d9e4028d6e0f967bebd7e4"

  bottle do
    cellar :any
    revision 2
    sha256 "3f69bb369fafd5c207f1c8ea500dc1e725e8e7dfe005215ff14b61fc25ac28e6" => :el_capitan
    sha256 "ace67ec808ae6963525164b700ace39c8552f0c68364415401fea532f3ea2fe2" => :yosemite
    sha256 "7c32b16f3528f615214dcca0633995ec01a70ff4db8badd09cbcc3a884fe64fc" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
