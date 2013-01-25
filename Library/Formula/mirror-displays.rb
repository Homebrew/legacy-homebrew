require 'formula'

class MirrorDisplays < Formula
  homepage 'https://github.com/aufflick/mirror-displays'
  url 'https://github.com/aufflick/mirror-displays/archive/1.03.tar.gz'
  version '1.03'
  sha1 'f3da3cf893a7f1d84dca6b09930fba095588ba6c'

  def install
    FileUtils.mkdir_p bin
    system "clang", "-framework", "Foundation", "-framework", "ApplicationServices",
                       "-o", "#{bin}/mirror-displays",
                       "mirror-displays.m"

    FileUtils.mkdir_p man1
    man1.install ["mirror-displays.1"]
  end

  def test
    # can't really test better than this since the command fails if the number of displays
    # doesn't == 2.
    system "mirror-displays -h > /dev/null 2>&1"
  end
end
