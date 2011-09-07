require 'formula'

class Dvdrtools < Formula
  homepage 'http://www.nongnu.org/dvdrtools/'
  url 'http://savannah.nongnu.org/download/dvdrtools/dvdrtools-0.2.1.tar.gz'
  md5 'e82d359137e716e8c0b04d5c73bd3e79'

  def patches
    macports_patches %w(
      patch-scsi-mac-iokit.c
      patch-cdda2wav-cdda2wav.c
      patch-cdrecord-cdrecord.c
    )
  end

  def install
    ENV['LIBS'] = '-lIOKit -framework CoreFoundation'

    system "./configure", '--disable-debug', '--disable-dependency-tracking',
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system 'make install'
  end

  # while homebrew assumes p1, macports patches at p0
  def macports_patches(files)
    { :p0 => files.map { |file| macports_patch_url('sysutils', file) } }
  end

  def macports_patch_url(group, file)
    template = 'http://svn.macports.org/repository/macports/trunk/dports/%s/%s/files/%s'
    template % [group, name, file]
  end
end
