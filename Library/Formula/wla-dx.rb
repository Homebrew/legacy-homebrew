require 'formula'

class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage 'https://github.com/vhelin/wla-dx'
  url 'https://github.com/vhelin/wla-dx/archive/v9.6.tar.gz'
  sha256 'd368f4fb7d8a394f65730682dba6fddfe75b3c6119756799cdb3cd5e1ae78e0d'

  head 'https://github.com/vhelin/wla-dx.git'

  def install
    %w{CFLAGS CXXFLAGS CPPFLAGS}.each { |e| ENV.delete(e) }
    ENV.append_to_cflags '-c -O3 -ansi -pedantic -Wall'
    chmod 0755, "unix.sh"
    system "./unix.sh", ENV.make_jobs
    bin.install Dir['./binaries/*']
  end
end
