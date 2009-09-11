require 'brewkit'

class Dmd <Formula
  @homepage='http://www.digitalmars.com/d/'
  @url='http://ftp.digitalmars.com/dmd.1.047.zip'
  @md5='9ca82389e82e3f39185f999d7dda4617'

  def doc
    #use d and not dmd, rationale: meh
    prefix+'share'+'doc'+'d'
  end

  def install
    ohai "Installing dmd"

    # clean it up a little first
    Dir['src/*.mak'].each {|f| File.unlink f}
    FileUtils.mv 'license.txt', 'COPYING'
    FileUtils.mv 'README.TXT', 'README'
    FileUtils.mv 'src/phobos/phoboslicense.txt', 'src/phobos/COPYING.phobos'

    prefix.install 'osx/lib'
    prefix.install 'osx/bin'
    prefix.install 'src'
    man.install 'man/man1'

    (prefix+'src'+'dmd').rmtree # we don't need the dmd sources thanks
    (man+'man5').install man1+'dmd.conf.5' # oops
    (prefix+'share'+'d'+'examples').install Dir['samples/d/*.d']

    (prefix+'bin'+'dmd.conf').open('w') do |f|
      f.puts "[Environment]"
      f.puts "DFLAGS=-I#{prefix}/src/phobos -L-L#{prefix}/lib"
    end
  end
end