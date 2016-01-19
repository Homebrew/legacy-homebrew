class Bibutils < Formula
  desc "Bibliography conversion utilities"
  homepage "https://sourceforge.net/p/bibutils/home/Bibutils/"
  url "https://downloads.sourceforge.net/project/bibutils/bibutils_5.6_src.tgz"
  sha256 "9fc7ba38b69379e501af9d6228f6e2ebaebcca52b6810583d901219d83537423"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "9a4e5494dc97e5402f578f19204cfada5c1d6fbb755d0a686d8cd0085ede3281" => :el_capitan
    sha256 "a37c6ed34d2f4cf336ed892774100ccca5b76bd5dd125df61ff2f51fb34c1acb" => :yosemite
    sha256 "dfebe0d374bb5aa13aac8fc37b0c39e77b3a662b25abc46fb3d3f804e13fc5cc" => :mavericks
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
