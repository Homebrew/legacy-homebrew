class Caudec < Formula
  desc "Covert audio files from one format to another"
  homepage "http://caudec.net"
  url "http://caudec.net/downloads/caudec-1.7.5.tar.gz"
  sha256 "5d1f5ab3286bb748bd29cbf45df2ad2faf5ed86070f90deccf71c60be832f3d5"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "4a559f4dcbed1881ad445e4b0710f1d831eb6e68d9c2ad04088d94cd0919580c" => :el_capitan
    sha256 "1b5c7cf4d5db8b361ed5fa4a9009773cd9f92533c5e5fd32472fdb69f03b3d4c" => :yosemite
    sha256 "69b97ad57eff1b7a58ce4857e7b83550fac6bb5d70c0a766f1ff8f66cbb926c3" => :mavericks
  end

  depends_on "gnu-sed"
  depends_on "shntool"
  depends_on "aacgain" => :optional
  depends_on "alac" => :optional
  depends_on "cksfv" => :optional
  depends_on "coreutils" => :optional
  depends_on "eye-d3" => :optional
  depends_on "ffmpeg" => :optional
  depends_on "flac" => :optional
  depends_on "flake" => :optional
  depends_on "lame" => :optional
  depends_on "mp3gain" => :optional
  depends_on "musepack" => :optional
  depends_on "opus" => :optional
  depends_on "sox" => :optional
  depends_on "vorbis-tools" => :optional
  depends_on "vorbisgain" => :optional
  depends_on "wavpack" => :optional
  depends_on "wget" => :optional

  def install
    bin.install "caudec"
    (bin/"decaude").make_symlink bin/"caudec"
    etc.install "caudecrc"
  end

  def caveats; <<-EOS.undent
    You can find an up-to-date caudecrc file in
    #{HOMEBREW_PREFIX}/etc

    Copy it to ~/.caudecrc ('.caudecrc' in your home directory),
    or update your existing copy as needed.

    EOS
  end
end
