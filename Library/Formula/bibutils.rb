class Bibutils < Formula
  homepage "http://sourceforge.net/p/bibutils/home/Bibutils/"
  url "https://downloads.sourceforge.net/project/bibutils/bibutils_5.5_src.tgz"
  sha1 "f7cb7a8bd62ac3b5f0caf63a4a6a793355a417f2"

  bottle do
    cellar :any
    sha1 "5fbb88c0bcab944cfa2a1445465632cc73f2d591" => :yosemite
    sha1 "4da4df14956e2261ed22360a6c734c84baa412c0" => :mavericks
    sha1 "7b108573b7bbcb3dd635ea96a01336607deaaae3" => :mountain_lion
  end

  def install
    system "./configure", "--install-dir", prefix
    system "make", "CC=#{ENV.cc}"

    cd "bin" do
      bin.install %w[bib2xml ris2xml end2xml endx2xml med2xml isi2xml copac2xml
                     biblatex2xml ebi2xml wordbib2xml xml2ads xml2bib xml2end
                     xml2isi xml2ris xml2wordbib modsclean]
    end
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
