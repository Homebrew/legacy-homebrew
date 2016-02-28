class RdiffBackup < Formula
  desc "Backs up one directory to another--also works over networks"
  homepage "http://rdiff-backup.nongnu.org/"
  url "https://savannah.nongnu.org/download/rdiff-backup/rdiff-backup-1.2.8.tar.gz"
  sha256 "0d91a85b40949116fa8aaf15da165c34a2d15449b3cbe01c8026391310ac95db"
  revision 1

  bottle do
    cellar :any
    sha256 "196b7306e685aa7b03b8a55f9a305316d102885437c4a99eaefcb9a26518f11e" => :el_capitan
    sha256 "c0a4e011807f1549616f5455d41e46d705a5e35218ab203f117d25a5d3061816" => :yosemite
    sha256 "508a818d9f53775e43a445d786688c3ee41858bf4be0041057a5b555e3964ead" => :mavericks
  end

  devel do
    url "https://savannah.nongnu.org/download/rdiff-backup/rdiff-backup-1.3.3.tar.gz"
    sha256 "ee030ce638df0eb1047cf72578e0de15d9a3ee9ab24da2dc0023e2978be30c06"
  end

  depends_on "librsync"

  # librsync 1.x support
  patch do
    url "http://pkgs.fedoraproject.org/cgit/rdiff-backup.git/plain/rdiff-backup-1.2.8-librsync-1.0.0.patch"
    sha256 "a00d993d5ffea32d58a73078fa20c90c1c1c6daa0587690cec0e3da43877bf12"
  end

  def install
    # Find the arch for the Python we are building against.
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    archs = archs_for_command("python")
    archs.remove_ppc!
    archs.delete :x86_64 if Hardware.is_32_bit?
    ENV["ARCHFLAGS"] = archs.as_arch_flags
    system "python", "setup.py", "--librsync-dir=#{prefix}", "build"
    libexec.install Dir["build/lib.macosx*/rdiff_backup"]
    libexec.install Dir["build/scripts-*/*"]
    man1.install Dir["*.1"]
    bin.install_symlink Dir["#{libexec}/rdiff-backup*"]
  end
end
