require 'formula'

class Ntfs3g < Formula
  homepage 'http://www.tuxera.com/community/ntfs-3g-download/'
  url 'http://tuxera.com/opensource/ntfs-3g_ntfsprogs-2014.2.15.tgz'
  sha1 'c9836f340b508f5d7776156e5afb02434d3f0174'

  bottle do
    sha1 "fe9fe60adee81fdb8fc5eb73bfbf5ac9d75db9e0" => :mavericks
    sha1 "dac4e91b2e2f42fed5e1b703bb80754b863d2059" => :mountain_lion
    sha1 "38407af2c691ff1cf6feb64030f9f29ac883e7b0" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'osxfuse'
  depends_on 'gettext'

  def install
    # Workaround for hardcoded /sbin in ntfsprogs
    inreplace "ntfsprogs/Makefile.in", "/sbin", sbin

    ENV.append "LDFLAGS", "-lintl"
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--exec-prefix=#{prefix}",
            "--mandir=#{man}",
            "--with-fuse=external"]

    system "./configure", *args
    system "make"
    system "make install"

    # Install a script that can be used to enable automount
    File.open("#{sbin}/mount_ntfs", File::CREAT|File::TRUNC|File::RDWR, 0755) do |f|
      f.puts <<-EOS.undent
      #!/bin/bash

      VOLUME_NAME="${@:$#}"
      VOLUME_NAME=${VOLUME_NAME#/Volumes/}
      USER_ID=#{Process.uid}
      GROUP_ID=#{Process.gid}

      if [ `/usr/bin/stat -f %u /dev/console` -ne 0 ]; then
        USER_ID=`/usr/bin/stat -f %u /dev/console`
        GROUP_ID=`/usr/bin/stat -f %g /dev/console`
      fi

      #{opt_bin}/ntfs-3g \\
        -o volname="${VOLUME_NAME}" \\
        -o local \\
        -o negative_vncache \\
        -o auto_xattr \\
        -o auto_cache \\
        -o noatime \\
        -o windows_names \\
        -o user_xattr \\
        -o inherit \\
        -o uid=$USER_ID \\
        -o gid=$GROUP_ID \\
        -o allow_other \\
        "$@" >> /var/log/mount-ntfs-3g.log 2>&1

      exit $?;
      EOS
    end
  end
end
