require 'brewkit'

# My god! 20,000 files?!
# TODO trim that a bit? Seems crazy.

class Jruby <Formula
  @url='http://dist.codehaus.org/jruby/1.3.1/jruby-src-1.3.1.tar.gz'
  @homepage='http://jruby.org/'
  @md5='c7e2aa4a3065db445a8b3e17ecff9fe0'

  def install
    system "ant"

    Dir.chdir 'bin' do
      FileUtils.rm Dir['*.bat']
      Dir['*'].each do |file|
        FileUtils.mv file, "j#{file}" unless file.match /^[j_]/
      end
    end

    prefix.install Dir['*']
  end
end
