class Cdrtools < Formula
  desc "CD/DVD/Blu-ray premastering and recording software"
  homepage "http://cdrecord.org/"

  stable do
    url "https://downloads.sourceforge.net/project/cdrtools/cdrtools-3.01.tar.bz2"
    sha256 "ed282eb6276c4154ce6a0b5dee0bdb81940d0cbbfc7d03f769c4735ef5f5860f"
  end

  bottle do
    revision 1
    sha256 "c5961aaef116ae0dd425197550ae59c91f16da2552992de6c44331685dea58b6" => :yosemite
    sha256 "6dad15e2cfc911cda652271f764b830fe913affc85c1e92407006141594ac267" => :mavericks
    sha256 "ab6ca1d2649635c76c83343eba34fe89b3720613cdeee5cf2ee82789c6fa0687" => :mountain_lion
  end

  depends_on "smake" => :build

  conflicts_with "dvdrtools",
    :because => "both dvdrtools and cdrtools install binaries by the same name"

  def install
    system "smake", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "install"
    # cdrtools tries to install some generic smake headers, libraries and
    # manpages, which conflict with the copies installed by smake itself
    (include/"schily").rmtree
    %w[libschily.a libdeflt.a libfind.a].each do |file|
      (lib/file).unlink
    end
    (lib/"profiled").rmtree
    man5.rmtree
  end

  test do
    system "#{bin}/cdrecord", "-version"
    system "#{bin}/cdda2wav", "-version"
    date = shell_output("date")
    (testpath/"testfile.txt").write(date)
    system "#{bin}/mkisofs", "-r", "-o", "test.iso", "testfile.txt"
    assert (testpath/"test.iso").exist?
  end
end
