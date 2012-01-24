require 'formula'

class Glusterfs < Formula
  homepage 'http://www.gluster.org'
  url 'https://github.com/mhubig/glusterfs.git', 
      :tag => '838224369845e7566bbbac24ffd70d166a3df422',
      :using => :git
  version '3.2git'

  head 'https://github.com/mhubig/glusterfs.git',
       :using => :git

  depends_on 'pkg-config' => :build
  depends_on 'fuse4x'

  def install
    ENV['ACLOCAL_FLAGS'] = "-I#{HOMEBREW_PREFIX}/share/aclocal"
    
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--with-launchddir=#{prefix}/Library/LaunchDaemons",
            "--with-mountutildir=#{prefix}/sbin",
            "--prefix=#{prefix}"]

    system "./autogen.sh"
    system "./configure", *args
    system "make install"
  end

  def test
    system "glusterfsd --version"
  end
end
