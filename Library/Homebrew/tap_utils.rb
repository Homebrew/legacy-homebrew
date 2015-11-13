require "tap"

module Homebrew
  # Migrate tapped formulae from symlink-based to directory-based structure.
  def migrate_taps(options = {})
    ignore = HOMEBREW_LIBRARY/"Formula/.gitignore"
    return unless ignore.exist? || options.fetch(:force, false)
    (HOMEBREW_LIBRARY/"Formula").children.each { |c| c.unlink if c.symlink? }
    ignore.unlink if ignore.exist?
  end

  private

  def tap_args(tap_name = ARGV.named.first)
    tap_name =~ HOMEBREW_TAP_ARGS_REGEX
    raise "Invalid tap name" unless $1 && $3
    [$1, $3]
  end
end
