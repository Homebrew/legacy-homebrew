require 'formula'

class Watchman < Formula
  homepage 'https://github.com/facebook/watchman'
  head 'https://github.com/facebook/watchman.git'
  url 'https://github.com/facebook/watchman/archive/v2.6.tar.gz'
  sha1 'dfae0fb3c61aa3751be998b2597ede54b85a6bef'

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

  test do
    # TODO testing requires 'arc': https://github.com/facebook/watchman#tools
    system "false"
  end
end
