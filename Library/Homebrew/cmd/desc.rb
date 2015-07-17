require 'descriptions'

module Homebrew
  def desc
    Descriptions.print(ARGV.named)
  end
end
