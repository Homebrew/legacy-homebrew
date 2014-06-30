require 'formula'

class Web100clt < Formula
  homepage 'http://www.internet2.edu/performance/ndt/'
  url 'http://software.internet2.edu/sources/ndt/ndt-3.6.5.2.tar.gz'
  sha1 '533a7dbb1b660a0148a0e295b481f63ab9ecb8f7'

  # fixes issue with new default secure strlcpy/strlcat functions in 10.9
  # https://code.google.com/p/ndt/issues/detail?id=106
  patch do
    url "https://gist.githubusercontent.com/igable/8077668/raw/4475e6e653f080be111fa0a3fd649af42fa14c3d/ndt-3.6.5.2-osx-10.9.patch"
    sha1 "1423d4b863049b21fcee4ecf9dd0660462406a39"
  end if MacOS.version >= :mavericks

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    # we only want to build the web100clt client so we need
    # to change to the src directory before installing.
    system "make", "-C", "src", "install"
    man1.install 'doc/web100clt.man' => 'web100clt.1'
  end

  test do
    system "#{bin}/web100clt", "-v"
  end
end
