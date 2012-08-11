# Yes, a good deal of this could be imported from Homebrew-proper
# But Homebrew-proper is dog-slow currently, and I didn't want every cc
# instantiation to be slower be a tangible amount.

class String
  def directory?; File.directory? self end
  def basename; File.basename self end
  def cleanpath; require 'pathname'; Pathname.new(self).realpath.to_s rescue self end
  def chuzzle; s = chomp; s unless s.empty? end
  def dirname; File.dirname(self) end
end

class NilClass
  def chuzzle; end
  def directory?; false end
  def split(x); [] end
end

class Array
  def to_flags prefix
    select{|path| path.directory? }.uniq.map{|path| prefix+path }
  end
end

module Kernel extend self
  alias :_exec :exec
  def exec *args
    path = File.expand_path('~/Library/Logs/Homebrew/cc.log')
    open(path, 'a') do |f|
      f.print '[', $0
      f.print " -%s" % ENV['HOMEBREW_CCCFG'] if ENV['HOMEBREW_CCCFG']
      f.print '] '
      f.puts args.join(' ')
      f.puts
    end
    _exec *args
  end
end if ENV['HOMEBREW_LOG']

$brewfix = "#{__FILE__}/../../../".cleanpath.freeze
$sdkroot = ENV['HOMEBREW_SDKROOT'].freeze
