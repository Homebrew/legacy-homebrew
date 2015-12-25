class Caudec < Formula
  desc "Covert audio files from one format to another"
  homepage "http://caudec.net"
  url "http://caudec.net/downloads/caudec-1.7.5.tar.gz"
  sha256 "5d1f5ab3286bb748bd29cbf45df2ad2faf5ed86070f90deccf71c60be832f3d5"
  revision 1

  bottle do
    sha256 "146d7d8a5d2a9ed8b0c40bb6183fd0431c952205fdbc21fb3eb6ff6d363bc4d5" => :yosemite
    sha256 "d04893008261cbde17cc6e658c376b122a901030cb640795b4867357a9739f46" => :mavericks
    sha256 "a1c38c8d6962089cfa617b90205d73d57f0dbb32d5ae6d6b2ba08f0052dc76b2" => :mountain_lion
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
