class RdiffBackup < Formula
  desc "Backs up one directory to another--also works over networks"
  homepage "http://rdiff-backup.nongnu.org/"
  url "https://savannah.nongnu.org/download/rdiff-backup/rdiff-backup-1.2.8.tar.gz"
  sha256 "0d91a85b40949116fa8aaf15da165c34a2d15449b3cbe01c8026391310ac95db"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "f06f79bc1536dbaa990e6005565f18de05e9dc12deb09701a504ab6bfc8b8f11" => :el_capitan
    sha256 "35f6a0f726a680d639f7a1c83af8e27d046d5a68a334bf19d47eaa363748767c" => :yosemite
    sha256 "5b0eab2335afe2d298cd51737c744d052536cb0bdbee780819496e1000a3b179" => :mavericks
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
