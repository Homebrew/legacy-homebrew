module Homebrew extend self
  def __prefix
    if ARGV.named.empty?
      puts HOMEBREW_PREFIX
    else
      puts ARGV.formulae.map{ |f| "#{HOMEBREW_PREFIX}/opt/#{f}" }
    end
  end
end
