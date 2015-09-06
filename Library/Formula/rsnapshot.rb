class Rsnapshot < Formula
  desc "File system snapshot utility (based on rsync)"
  homepage "http://rsnapshot.org"
  url "http://rsnapshot.org/downloads/rsnapshot-1.4.1.tar.gz"
  sha256 "fb4a1129a7d3805c41749fd0494debfe2ca2341eba0f8b50e4f54985efe448e8"

  head "https://github.com/DrHyde/rsnapshot.git"

  bottle do
    cellar :any
    sha256 "460ba04ddd94ef8e2837c3425be24bd9cad1de2979cad39af22c5baca6014005" => :yosemite
    sha256 "f8b7c4ff9d8a8af8367dc33961f94e539cb086eb4bca590333ffe48fde787f30" => :mavericks
    sha256 "30bb210aaf9690fe3ad222c8e49a18f64d314441e1d5ef574d661d9e82a8cd72" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end
end
