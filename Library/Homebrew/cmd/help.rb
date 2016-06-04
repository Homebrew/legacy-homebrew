HOMEBREW_HELP = <<-EOS
Please run brew update!
EOS

module Homebrew
  def help
    puts HOMEBREW_HELP
  end

  def help_s
    HOMEBREW_HELP
  end
end
