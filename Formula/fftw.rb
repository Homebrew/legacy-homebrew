$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'

homepage='http://www.fftw.org'
url='http://www.fftw.org/fftw-3.2.1.tar.gz'
md5='712d3f33625a0a76f5758648d4b925f7'

Formula.new(url, md5).brew do |prefix|
  configure=<<-EOS
  ./configure --enable-shared --disable-debug --prefix='#{prefix}'
              --enable-threads --enable-single --enable-sse
              --disable-dependency-tracking
              --disable-fortran
              EOS
  system configure.gsub("\n", ' ').strip.squeeze(' ')
  system "make install"
end