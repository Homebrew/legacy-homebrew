require 'formula'

class Leveldb < Formula
  head 'http://leveldb.googlecode.com/svn/trunk/', :using => :svn
  homepage 'http://code.google.com/p/leveldb/'

  def options
    [
      ['--bench', '"brew test --bench" to execute a performance benchmark test.']
    ]
  end

  def install
    system 'make all'

    prefix.install Dir['*_test', 'db_bench']
    doc.install Dir['doc/*']
    include.install Dir['include/*']
    lib.install 'libleveldb.a'
  end

  def test
    errorCode = 0

    if ARGV.include? '--bench'
      # Use Kernel::system so the output always gets printed
      # (the benchmark may take a little while, better to print
      # something than to leave the user wondering)
      errorCode = $? if (Kernel::system prefix+'db_bench') != nil
    else
      puts 'Pass --bench to run performance benchmark.'
      Dir[prefix+'*_test'].each do |test|
        errorCode |= $? if (system test) != nil
      end
    end

    errorCode
  end
end
