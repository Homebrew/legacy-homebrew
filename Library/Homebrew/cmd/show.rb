module Homebrew extend self
  def show
    raise SHAUnspecifiedError if ARGV.named.empty?
    sha = ARGV.pop
    exec "git", "show", sha
  end
end
