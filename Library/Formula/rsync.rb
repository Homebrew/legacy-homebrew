require 'formula'

class Rsync < Formula
  url 'http://rsync.samba.org/ftp/rsync/src/rsync-3.0.8.tar.gz'
  homepage 'http://rsync.samba.org/'
  md5 '0ee8346ce16bdfe4c88a236e94c752b4'

  def patches
    [
      # Preserve file flags when using --fileflags
      'http://gitweb.samba.org/?p=rsync-patches.git;a=blob_plain;f=fileflags.diff;hb=75fb8c6938caf8b2863a53fc207b1fba8c2f62ba',
      # Preserve creation time on OS X when using --crtimes or -N
      'http://gitweb.samba.org/?p=rsync-patches.git;a=blob_plain;f=crtimes.diff;hb=75fb8c6938caf8b2863a53fc207b1fba8c2f62ba',
      # Handle compressed files on HFS+ volumes gracefully
      'http://gitweb.samba.org/?p=rsync-patches.git;a=blob_plain;f=hfs-compression.diff;hb=75fb8c6938caf8b2863a53fc207b1fba8c2f62ba'
    ]
  end

  def install
    system "./prepare-source"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
