# A private interface for `brew` to run its own internal APIs in a separate `brew` command
#
# This is not intended for use as an end-user command or public API. Any of its behavior
# is subject to change at any time.

module Homebrew
  def _internal
    if ARGV.named.empty?
      odie "This command requires at least one argument naming a subcommand"
    end
    subcommand_name = ARGV.named.first
    other_args = ARGV.named[1..-1]

    case subcommand_name
      when "verify-bintray-publish"
        require "cmd/pull"
        verify_bintray_publish(other_args)
      when "fetch-bottle-any-arch"
        require "cmd/fetch"
        fetch_bottle_any_arch(other_args)
      else
        odie "Invalid _internal subcommand: #{subcommand_name}"
    end
  end
end