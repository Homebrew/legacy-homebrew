require 'formula'

class JadHttpDownloadStrategy <CurlDownloadStrategy
  def stage
    # need to unzip quietly as the jad{,.1} files in the zip are in the "../" directory, which unzip complains about otherwise
    safe_system '/usr/bin/unzip', '-q', @tarball_path
    chdir
  end
end

class Jad <Formula
  url 'http://www.varaneckas.com/sites/default/files/jad/jad158g.mac.intel.zip',
        :using => JadHttpDownloadStrategy
  version '1.5.8g'
  homepage 'http://www.varaneckas.com/jad'
  sha256 '8e9e4ea6c4177acce6d27325a036f10a72c170ed60e48c37c3483335319d07b9'

  def install
    bin.install('jad')
    man1.install('jad.1')
  end
end
