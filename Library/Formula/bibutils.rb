class Bibutils < Formula
  desc "Bibliography conversion utilities"
  homepage "http://sourceforge.net/p/bibutils/home/Bibutils/"
  url "https://downloads.sourceforge.net/project/bibutils/bibutils_5.6_src.tgz"
  sha1 "effec35d97ed2d8454721eaf37ba8b484f02e8da"

  bottle do
    cellar :any
    sha1 "036d3e0326d28f905d2b7cf8dac92a41f7e85f72" => :yosemite
    sha1 "a0d6d70b5fc7f64977c1cddb9dcc6f9e20455da8" => :mavericks
    sha1 "6648845e6ff3a5318ecfa08498cea7f4d3436de9" => :mountain_lion
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
