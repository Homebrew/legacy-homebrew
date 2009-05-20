$:.unshift "#{File.dirname __FILE__}/../Cellar/homebrew" #rubysucks
require 'brewkit'

homepage='http://www.digitalmars.com/d/'
url='http://ftp.digitalmars.com/dmd.1.043.zip'
md5='6c83b7296cb84090a9ebc11ab0fb94a2'

Formula.new(url, md5).brew do |prefix|
  prefix.mkpath
  FileUtils.cp_r 'osx/bin', prefix
  FileUtils.cp_r 'osx/lib', prefix
  FileUtils.cp_r 'man', prefix
  FileUtils.cp_r 'man', prefix
  
  share=prefix+'share'+'doc'+'d'
  html=share+'html'
  samples=share+'examples' #examples is the more typical directory name
  html.mkpath
  samples.mkpath
  
  FileUtils.cp_r Dir['html/d/*'], html unless ARGV.include? '--no-html'
  FileUtils.cp_r Dir['samples/d/*'], samples unless ARGV.include? '--no-samples'
end