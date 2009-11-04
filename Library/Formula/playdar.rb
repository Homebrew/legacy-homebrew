require 'formula'

class Playdar <Formula
  homepage 'http://www.playdar.org'
  head 'git://github.com/RJ/playdar-core.git'

  depends_on 'taglib'
  depends_on 'erlang'

  def install
    system "make all"
    system "make scanner"

    Dir['playdar_modules/*/src'].each{ |fn| FileUtils.rm_rf fn }
    FileUtils.rm_rf 'playdar_modules/library/priv/taglib_driver/scanner_visual_studio_sln'
    File.unlink 'playdar_modules/library/priv/taglib_driver/taglib_json_reader.cpp'

    prefix.install 'ebin'
    prefix.install 'playdar_modules'
    prefix.install 'priv'
    prefix.install 'etc' # otherwise playdar crashes
    
    inreplace 'playdarctl', 'cd `dirname $0`', "cd #{prefix}"
    inreplace 'playdarctl', 'EBIN=./ebin/', "EBIN=#{prefix}/ebin"
    
    bin.install 'playdarctl'
  end
end
