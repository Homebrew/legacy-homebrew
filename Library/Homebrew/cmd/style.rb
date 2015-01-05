module Homebrew
  def style
    target = if ARGV.named.empty?
      [HOMEBREW_LIBRARY]
    else
      ARGV.formulae.map(&:path)
    end

    Homebrew.install_gem_setup_path! "rubocop"

    system "rubocop", "--format", "simple", "--config",
                      "#{HOMEBREW_LIBRARY}/.rubocop.yml", *target
    Homebrew.failed = !$?.success?
  end
end
