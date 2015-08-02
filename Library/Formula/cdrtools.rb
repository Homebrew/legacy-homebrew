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
    sha1 "497614205a68d26bcbefce88c37cbebd9e573202" => :yosemite
    sha1 "d5041283713c290cad78f426a277d376a9e90c49" => :mavericks
    sha1 "434f1296db4fb7c082bed1ba25600322c8f31c78" => :mountain_lion
  end

  devel do
    url "https://downloads.sourceforge.net/project/cdrtools/alpha/cdrtools-3.01a30.tar.bz2"
    sha256 "5b9a2f98771c9d0097a1e7640727655ece2864eea95f38e5611af2b2f6e6d9cd"
  end

  depends_on 'smake' => :build

  conflicts_with 'dvdrtools',
    :because => 'both dvdrtools and cdrtools install binaries by the same name'

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
