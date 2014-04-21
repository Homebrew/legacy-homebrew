# Yes, a good deal of this could be imported from Homebrew-proper
# But Homebrew-proper is dog-slow currently, and I didn't want every cc
# instantiation to be slower by a tangible amount.

# https://github.com/Homebrew/homebrew-versions/issues/47
$:.unshift "/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8"

class String
  def chuzzle; s = chomp; s unless s.empty? end
end

class NilClass
  def chuzzle; end
end
