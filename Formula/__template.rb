$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'

homepage=''
url=''
md5='' # leave this blank and brewkit will error out, but show you the md5

Formula.new(url, md5).brew do |prefix|
  system "./configure --disable-debug --prefix='#{prefix}'"
  system "make install" # if this fails, split into two steps
end