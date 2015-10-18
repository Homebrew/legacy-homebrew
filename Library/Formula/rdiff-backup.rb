class RdiffBackup < Formula
  desc "Backs up one directory to another--also works over networks"
  homepage "http://rdiff-backup.nongnu.org/"
  url "http://download.savannah.nongnu.org/releases/rdiff-backup/rdiff-backup-1.2.8.tar.gz"
  sha256 "0d91a85b40949116fa8aaf15da165c34a2d15449b3cbe01c8026391310ac95db"

  bottle do
    cellar :any
    revision 1
    sha256 "b225a08ee7acb4d78411a4a2ca44c2511ac51eb967fc3c8e8e757723080faef9" => :el_capitan
    sha256 "4572a21d264f12bce6b4a1f4e632b37f3414d449f71200ce5fa1f21374742abb" => :yosemite
    sha256 "b23e00088fff7503b82b6bc6d56c097e8f291d98afc7d6c2605bd99e769cd844" => :mavericks
  end

  devel do
    url "http://download.savannah.nongnu.org/releases/rdiff-backup/rdiff-backup-1.3.3.tar.gz"
    sha256 "ee030ce638df0eb1047cf72578e0de15d9a3ee9ab24da2dc0023e2978be30c06"
  end

  depends_on "librsync"

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
