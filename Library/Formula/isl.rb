require 'formula'

class Isl < Formula
  homepage 'http://www.kotnet.org/~skimo/isl/'
  url 'http://www.kotnet.org/~skimo/isl/isl-0.12.tar.bz2'
  mirror 'ftp://ftp.linux.student.kuleuven.be/pub/people/skimo/isl/isl-0.12.tar.bz2'
  sha1 'f694b741530676cd1ea27a6437bd090c69e61455'

  head 'http://repo.or.cz/w/isl.git'

  depends_on 'gmp'

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking"
    ]

    system "./configure", *args
    system "make install"

    # move gdb helper to proper location
    (share+'gdb/auto-load').mkpath

    Dir.glob(lib+'*-gdb.py', File::FNM_DOTMATCH).each do |gdbf|
      ohai "#{gdbf} moved to #{share+'gdb/auto-load/'}"
      FileUtils.move gdbf, share+'gdb/auto-load/'
    end
end
