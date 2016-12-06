require 'formula'

class Rar2fs < Formula
  homepage 'http://code.google.com/p/rar2fs/'
  url 'http://rar2fs.googlecode.com/files/rar2fs-1.17.2.tar.gz'
  sha1 'b47286dc0f10314dd80e36135aab9b9727a0237b'

  depends_on 'libunrar'
  depends_on 'fuse4x'
  depends_on 'curl' # to download unrar sources for the build

  LIB_UNRAR_VER = `#{HOMEBREW_PREFIX}/bin/brew info libunrar | head -1 | cut -d' ' -f 3`.delete("\n")
  TMP_DIR  = `mktemp -d /tmp/temp.XXXX`.delete("\n")
  UNRAR_SRC_FILE = 'unrarsrc-' + LIB_UNRAR_VER + '.tar.gz'
  
  def install
    # As rar2fs needs the unrar sources, fetch it
    curl '-s', '-o', '/tmp/' + UNRAR_SRC_FILE, 'http://www.rarlab.com/rar/' + UNRAR_SRC_FILE
    system 'tar', 'xzf', '/tmp/' + UNRAR_SRC_FILE, '-C', TMP_DIR

    system './configure', '--with-unrar=' + TMP_DIR + '/unrar'
    system 'make', 'install'

    # delete unrar sources if all OK
    system 'rm', '-rf', TMP_DIR
    system 'rm', '-rf', '/tmp/' + UNRAR_SRC_FILE
  end
end
