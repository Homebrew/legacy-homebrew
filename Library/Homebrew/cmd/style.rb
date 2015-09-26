module Homebrew
  def style
    target = if ARGV.named.empty?
      [HOMEBREW_LIBRARY]
    elsif ARGV.named.any? { |file| File.exist? file }
      ARGV.named
    else
      ARGV.formulae.map(&:path)
    end

    Homebrew.install_gem_setup_path! "rubocop", "0.34.2"

    args = [
      "--format", "simple", "--force-exclusion", "--config",
      "#{HOMEBREW_LIBRARY}/.rubocop.yml",
    ]

    args << "--auto-correct" if ARGV.homebrew_developer? && ARGV.flag?("--fix")

    args += target

    system "rubocop", *args
    Homebrew.failed = !$?.success?
  end
end
