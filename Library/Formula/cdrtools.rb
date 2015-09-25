class Cdrtools < Formula
  desc "CD/DVD/Blu-ray premastering and recording software"
  homepage "http://cdrecord.org/"

  stable do
    url "https://downloads.sourceforge.net/project/cdrtools/cdrtools-3.01.tar.bz2"
    sha256 "ed282eb6276c4154ce6a0b5dee0bdb81940d0cbbfc7d03f769c4735ef5f5860f"
  end

  bottle do
    sha256 "db5a7311eb178ae4b0f99596d0475cd99af0a843b1eb4a988b6708517d585cdf" => :el_capitan
    sha256 "bc99e1777e2723361b2c410ac8665eac163e0269815b04c4d1e0f28fa036193d" => :yosemite
    sha256 "825662b7641aa454f1d1aee4bcc4968e9d74887988af5d793e33aa2a92e420d8" => :mavericks
    sha256 "8f4e80ac5e512312227029504b52d39085c80b5f7d1f06d0911aaf0eaca1b6a5" => :mountain_lion
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
