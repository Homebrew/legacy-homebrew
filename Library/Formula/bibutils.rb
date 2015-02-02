class Bibutils < Formula
  homepage "http://sourceforge.net/p/bibutils/home/Bibutils/"
  url "https://downloads.sourceforge.net/project/bibutils/bibutils_5.6_src.tgz"
  sha1 "effec35d97ed2d8454721eaf37ba8b484f02e8da"

  bottle do
    cellar :any
    sha1 "5fbb88c0bcab944cfa2a1445465632cc73f2d591" => :yosemite
    sha1 "4da4df14956e2261ed22360a6c734c84baa412c0" => :mavericks
    sha1 "7b108573b7bbcb3dd635ea96a01336607deaaae3" => :mountain_lion
  end

  def install
    system "./configure", "--install-dir", bin,
                          "--install-lib", lib
    system "make", "install", "CC=#{ENV.cc}"
  end

  test do
    (testpath/"test.bib").write <<-EOS.undent
      @article{Homebrew,
          title   = {Something},
          author  = {Someone},
          journal = {Something},
          volume  = {1},
          number  = {2},
          pages   = {3--4}
      }
    EOS

    system "#{bin}/bib2xml", "test.bib"
  end
end
