require 'formula'

# My god! 20,000 files?!
# TODO trim that a bit? Seems crazy.

class Jruby < Formula
  url 'http://jruby.kenai.com/downloads/1.4.0/jruby-src-1.4.0.tar.gz'
  homepage 'http://www.jruby.org'
  md5 'a363b6c2ea24f0ef8df478c93ac8cc59'

  def install
    Dir.chdir 'bin' do
      FileUtils.rm Dir['*.bat']
      FileUtils.rm Dir['*.exe']
      FileUtils.rm Dir['*.dll']
      Dir['*'].each do |file|
        FileUtils.mv file, "j#{file}" unless file.match /^[j_]/
      end
    end
    
    # Only keep the MacOSX native libraries
    Dir.chdir 'lib/native' do
      Dir['*'].each do |file|
        FileUtils.rm_rf file unless file == 'darwin'
      end
    end

    prefix.install Dir['*']
  end
end
