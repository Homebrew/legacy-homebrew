require 'brewkit'

class Dmd <Formula
  @homepage='http://www.digitalmars.com/d/'
  @url='http://ftp.digitalmars.com/dmd.1.043.zip'
  @md5='6c83b7296cb84090a9ebc11ab0fb94a2'

  def doc
    #use d and not dmd, rationale: meh
    prefix+'share'+'doc'+'d'
  end

  def install
    ohai "install"
    man.mkpath
    
    FileUtils.cp_r 'osx/bin', prefix
    FileUtils.cp_r 'osx/lib', prefix
    FileUtils.cp_r 'man/man1', man
    FileUtils.cp_r 'src', prefix

    #lol
    man5=man+'man5'
    man5.mkpath
    man5.install man+'man1'+'dmd.conf.5'
    #lol ends

    html=doc+'html'
    samples=doc+'examples' #examples is the more typical directory name
    html.mkpath
    samples.mkpath

    FileUtils.cp_r Dir['html/d/*'], html unless ARGV.include? '--no-html'
    FileUtils.cp_r Dir['samples/d/*'], samples unless ARGV.include? '--no-samples'

    # zip files suck
    FileUtils.chmod 0544, ['dmd','dumpobj','obj2asm'].collect{|x|"osx/bin/#{x}"}

    (prefix+'bin'+'dmd.conf').open('w') do |f|
      f.puts "[Environment]"
      f.puts "DFLAGS=-I#{prefix}/src/phobos -L-L#{prefix}/lib"
    end
  end
end