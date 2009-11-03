require 'formula'

# My god! 20,000 files?!
# TODO trim that a bit? Seems crazy.

class Jruby < Formula
  url 'http://jruby.kenai.com/downloads/1.4.0/jruby-bin-1.4.0.tar.gz'
  homepage 'http://www.jruby.org'
  md5 'f37322c18e9134e91e064aebb4baa4c7'

  def install
    system "ant"

    Dir.chdir 'bin' do
      FileUtils.rm Dir['*.bat']
      Dir['*'].each do |file|
        FileUtils.mv file, "j#{file}" unless file.match /^[j_]/
      end
    end
    
    # Only keep the MacOSX native libraries
    Dir.chdir 'lib/native' do
      Dir['*'].each do |file|
        FileUtils.rm_f file unless file == 'darwin'
      end
    end

    prefix.install Dir['*']
  end
end
