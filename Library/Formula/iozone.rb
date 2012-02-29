require 'formula'

# homebrew only untars if gz or bzip :(
class TarDownloadStrategy < CurlDownloadStrategy
  def stage
      safe_system '/usr/bin/tar', 'xf', @tarball_path
  end
end

class Iozone < Formula
  homepage 'http://www.iozone.org/'
  url 'http://www.iozone.org/src/current/iozone3_398.tar',
    :using => TarDownloadStrategy
  md5 'ac6e7534c77602a1c886f3bb8679ad2a'

  def patches
    # adds O_DIRECT support when using -I flag
    "https://raw.github.com/gist/1939253/iozone_directio_osx.patch"
  end

  def install
    system "make -C iozone3_398/src/current macosx"
    bin.install 'iozone3_398/src/current/iozone'
    man1.install 'iozone3_398/docs/iozone.1'
  end

  def test
    `iozone -I -s 16M | grep -c O_DIRECT`.chomp == '1'
  end
end
