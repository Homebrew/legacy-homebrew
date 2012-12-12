require 'formula'

class Irods < Formula
  homepage 'https://www.irods.org'
  url 'https://www.irods.org/cgi-bin/upload16.cgi/irods3.2.tgz'
  version '3.2'
  sha1 'd1dd7787e69cfda96b7719af2e50ffbc68485a23'

  option 'with-fuse', 'Install iRODS FUSE client'
  depends_on 'fuse4x' if build.include? 'with-fuse'

  def install
    system "./scripts/configure"
    system "make"
    bin.install Dir['clients/icommands/bin/*'].select {|f| File.executable? f}
    if build.include? 'with-fuse'
      # patch in order to use fuse4x
      inreplace 'config/config.mk', '# IRODS_FS = 1', 'IRODS_FS = 1'
      inreplace 'config/config.mk', 'fuseHomeDir=/home/mwan/adil/fuse-2.7.0', "fuseHomeDir=#{HOMEBREW_PREFIX}"
      chdir 'clients/fuse' do
        inreplace 'Makefile', 'lfuse', 'lfuse4x'
        system "make"
      end
      bin.install Dir['clients/fuse/bin/*'].select {|f| File.executable? f}
    end
  end

  def test
    system "ipwd"
  end
end
