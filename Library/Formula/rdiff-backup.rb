require 'formula'

class RdiffBackup < Formula
  url 'http://savannah.nongnu.org/download/rdiff-backup/rdiff-backup-1.2.8.tar.gz'
  homepage 'http://rdiff-backup.nongnu.org/'
  md5 '1a94dc537fcf74d6a3a80bd27808e77b'

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

    bin.mkpath
    Dir.chdir libexec do
      Dir['rdiff-backup*'].each do |f|
        ln_s libexec+f, bin
      end
    end

    man1.install Dir['*.1']
  end
end
