require "tap"

module Homebrew
  def tap
    if ARGV.include? "--repair"
      Tap.each(&:link_manpages)
      migrate_taps :force => true
    elsif ARGV.include? "--list-official"
      require "official_taps"
      puts OFFICIAL_TAPS.map { |t| "homebrew/#{t}" }
    elsif ARGV.include? "--list-pinned"
      puts Tap.select(&:pinned?).map(&:name)
    elsif ARGV.named.empty?
      puts Tap.names
    else
      tap = Tap.fetch(ARGV.named[0])
      begin
        tap.install :clone_target => ARGV.named[1],
                    :full_clone   => ARGV.include?("--full"),
                    :quiet        => ARGV.quieter?
      rescue TapAlreadyTappedError => e
        opoo e
      end
    end
  end

  # @deprecated this method will be removed in the future, if no external commands use it.
  def install_tap(user, repo, clone_target = nil)
    opoo "Homebrew.install_tap is deprecated, use Tap#install."
    tap = Tap.fetch(user, repo)
    begin
      tap.install(:clone_target => clone_target, :full_clone => ARGV.include?("--full"))
    rescue TapAlreadyTappedError
      false
    else
      true
    end
  end

  # Migrate tapped formulae from symlink-based to directory-based structure.
  def migrate_taps(options = {})
    ignore = HOMEBREW_LIBRARY/"Formula/.gitignore"
    return unless ignore.exist? || options.fetch(:force, false)
    (HOMEBREW_LIBRARY/"Formula").children.each { |c| c.unlink if c.symlink? }
    ignore.unlink if ignore.exist?
  end
end
