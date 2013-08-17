require 'formula'

class Rar2fs < Formula
  homepage 'http://code.google.com/p/rar2fs/'
  url 'http://rar2fs.googlecode.com/files/rar2fs-1.17.2.tar.gz'
  sha1 'b47286dc0f10314dd80e36135aab9b9727a0237b'

  depends_on 'libunrar'
  depends_on 'fuse4x'

  def install
    libunrar_ver = `#{HOMEBREW_PREFIX}/bin/brew info libunrar | head -1 | cut -d' ' -f 3`.delete("\n")
    tmp_dir  = `mktemp -d /tmp/temp.XXXX`.delete("\n")
    unrar_src_file = 'unrarsrc-' + libunrar_ver + '.tar.gz'
  
    # As rar2fs needs the unrar sources, fetch it
    curl '-s', '-o', '/tmp/' + unrar_src_file, 'http://www.rarlab.com/rar/' + unrar_src_file
    system 'tar', 'xzf', '/tmp/' + unrar_src_file, '-C', tmp_dir

    system './configure', '--with-unrar=' + tmp_dir + '/unrar'
    system 'make', 'install'

    # delete unrar sources if all OK
    system 'rm', '-rf', tmp_dir
    system 'rm', '-rf', '/tmp/' + unrar_src_file
  end
end
