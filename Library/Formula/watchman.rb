require 'formula'

class Watchman < Formula
  homepage 'https://github.com/facebook/watchman'
  head 'https://github.com/facebook/watchman.git'
  url 'https://github.com/facebook/watchman/archive/v2.8.1.tar.gz'
  sha1 'ff0a0b57365f9c10cc9a3c4c9df42783dbc75977'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'pcre' => :recommended

  def install
    system "./autogen.sh"
    if build.with? 'pcre'
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--with-pcre", "--prefix=#{prefix}"
    else
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
    end
    system "make"
    system "make install"
  end

  def caveats
    # display OSX specific notes about file handle size limits:
    <<-EOS.undent
To increase file limits add 'kern.maxfiles=10485760' and 'kern.maxfilesperproc=10485760'
to /etc/sysctl.conf (use 'sysctl -w' to do so immediately).
    
See https://github.com/facebook/watchman#max-os-file-descriptor-limits
    EOS
  end
end
