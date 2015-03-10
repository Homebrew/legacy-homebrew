class Mmv < Formula
  homepage "https://packages.debian.org/unstable/utils/mmv"
  url "https://mirrors.kernel.org/debian/pool/main/m/mmv/mmv_1.01b.orig.tar.gz"
  mirror "http://ftp.us.debian.org/debian/pool/main/m/mmv/mmv_1.01b.orig.tar.gz"
  sha256 "0399c027ea1e51fd607266c1e33573866d4db89f64a74be8b4a1d2d1ff1fdeef"

  patch do
    url "http://ftp.us.debian.org/debian/pool/main/m/mmv/mmv_1.01b-15.diff.gz"
    sha256 "9ad3e3d47510f816b4a18bae04ea75913588eec92248182f85dd09bc5ad2df13"
  end

  def install
    system "make", "CC=#{ENV.cc}", "LDFLAGS="

    bin.install "mmv"
    man1.install "mmv.1"

    %w[mcp mad mln].each do |mxx|
      bin.install_symlink "mmv" => mxx
      man1.install_symlink "mmv.1" => "#{mxx}.1"
    end
  end

  test do
    touch testpath/"a"
    touch testpath/"b"
    pipe_output(bin/"mmv", "a b\nb c\n")
    assert !(testpath/"a").exist?
    assert (testpath/"c").exist?
  end
end
