class Cdrtools < Formula
  desc "CD/DVD/Blu-ray premastering and recording software"
  homepage "http://cdrecord.org/"

  stable do
    url "https://downloads.sourceforge.net/project/cdrtools/cdrtools-3.00.tar.bz2"
    sha256 "7f9cb64820055573b880f77b2f16662a512518336ba95ab49228a1617973423d"

    patch :p0 do
      url "https://trac.macports.org/export/104091/trunk/dports/sysutils/cdrtools/files/patch-include_schily_sha2.h"
      sha256 "59a62420138c54fbea6eaa10a11f69488bb3fecf4f954fda47a3b1e424671d61"
    end
  end

  bottle do
    revision 1
    sha256 "c5961aaef116ae0dd425197550ae59c91f16da2552992de6c44331685dea58b6" => :yosemite
    sha256 "6dad15e2cfc911cda652271f764b830fe913affc85c1e92407006141594ac267" => :mavericks
    sha256 "ab6ca1d2649635c76c83343eba34fe89b3720613cdeee5cf2ee82789c6fa0687" => :mountain_lion
  end

  devel do
    url "https://downloads.sourceforge.net/project/cdrtools/alpha/cdrtools-3.01a31.tar.bz2"
    sha256 "183b5c12777779e78d8b69461aae52401f863768e7e7391d60730006f8cadc5a"
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
    (testpath/"testfile.txt").write("testing mkisofs")
    system "#{bin}/mkisofs", "-r", "-o", "test.iso", "testfile.txt"
    assert (testpath/"test.iso").exist?
  end
end
