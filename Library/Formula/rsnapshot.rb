class Rsnapshot < Formula
  desc "File system snapshot utility (based on rsync)"
  homepage "http://rsnapshot.org"
  url "https://github.com/rsnapshot/rsnapshot/releases/download/1.4.2/rsnapshot-1.4.2.tar.gz"
  sha256 "042a81c45b325296b21c363f417985d857f083f87c5c27f5a64677a052f24e16"

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
