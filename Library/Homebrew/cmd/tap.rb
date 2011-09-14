require 'taproom'

module Homebrew extend self
  def print_tap_usage
    puts <<-EOS
Usage: brew tap <command> [args]
Commands:

list
  List available alternate repositories.

add <repository>
remove <repository>
  Clone alternate repositories with add. Delete them with remove.

See 'man brew' for more detailed information.
    EOS
    exit 0
  end

  def tap
    print_tap_usage if ARGV.empty?

    case cmd = ARGV.shift
    when 'add'
      raise "A repository name must be passed to brew-tap add!" if ARGV.empty?
      brewery_name = ARGV.shift
      HOMEBREW_TAPROOM.tap! brewery_name

    when 'help'
      print_tap_usage

    when 'list'
      # Lists tapped repositories and available repositories separately. The
      # list of available repositories is generated from the fork network of
      # the "founding brewery" using the GitHub API. This list is only updated
      # when `brew tap update` is called.
      ohai "Repositories on tap:\n"
      HOMEBREW_TAPROOM.tapped.each do |brewery|
        puts <<-EOS.undent
        #{brewery.id}
          Brewmaster: #{brewery.owner}

        EOS
      end

      ohai "Untapped repositories (clone with `brew tap add repo_name`):\n"
      HOMEBREW_TAPROOM.untapped.each do |brewery|
        puts <<-EOS.undent
        #{brewery.id}
          Brewmaster: #{brewery.owner}

        EOS
      end

      ohai "Menu last updated: #{HOMEBREW_TAPROOM.menu[:menu_updated]}"

    when 'remove'
      raise "A repository name must be passed to brew-tap remove!" if ARGV.empty?
      brewery_name = ARGV.shift
      HOMEBREW_TAPROOM.remove! brewery_name

    else
      onoe "Invalid command for brew-tap: #{cmd}"
      print_tap_usage

    end
  end
end
