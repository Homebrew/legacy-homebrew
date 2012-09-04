require 'formula'

class RdiffBackup < Formula
  homepage 'http://rdiff-backup.nongnu.org/'
  url 'http://savannah.nongnu.org/download/rdiff-backup/rdiff-backup-1.2.8.tar.gz'
  sha1 '14ffe4f5b46a8a96ded536c1d03ae5e85faae318'

  depends_on 'librsync'

  def install
    # Find the arch for the Python we are building against.
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    archs = archs_for_command("python")
    archs.remove_ppc!
    archs.delete :x86_64 if Hardware.is_32_bit?
    ENV['ARCHFLAGS'] = archs.as_arch_flags

    system "python", "setup.py", "--librsync-dir=#{prefix}", "build"

    libexec.install Dir['build/lib.macosx*/rdiff_backup']
    libexec.install Dir['build/scripts-*/*']
    man1.install Dir['*.1']
    bin.install_symlink Dir["#{libexec}/rdiff-backup*"]
  end
end
