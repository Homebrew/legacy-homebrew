require "cmd/linkapps"

module Homebrew
  def unlinkapps
    target_dir = linkapps_target(:local => ARGV.include?("--local"))

    unlinkapps_from_dir(target_dir, :dry_run => ARGV.dry_run?)
  end

  private

  def unlinkapps_prune(opts = {})
    opts = opts.merge(:prune => true)
    unlinkapps_from_dir(linkapps_target(:local => false), opts)
    unlinkapps_from_dir(linkapps_target(:local => true), opts)
  end

  def unlinkapps_from_dir(target_dir, opts = {})
    return unless target_dir.directory?
    dry_run = opts.fetch(:dry_run, false)
    quiet = opts.fetch(:quiet, false)

    apps = Pathname.glob("#{target_dir}/*.app").select do |app|
      unlinkapps_unlink?(app, opts)
    end

    ObserverPathnameExtension.reset_counts!

    app_kind = opts.fetch(:prune, false) ? " (broken link)" : ""
    apps.each do |app|
      app.extend(ObserverPathnameExtension)
      if dry_run
        puts "Would unlink#{app_kind}: #{app}"
      else
        puts "Unlinking#{app_kind}: #{app}" unless quiet
        app.unlink
      end
    end

    return if dry_run

    if ObserverPathnameExtension.total.zero?
      puts "No apps unlinked from #{target_dir}" if ARGV.verbose?
    else
      n = ObserverPathnameExtension.total
      puts "Unlinked #{n} app#{plural(n)} from #{target_dir}"
    end
  end

  UNLINKAPPS_PREFIXES = %W[
    #{HOMEBREW_CELLAR}/
    #{HOMEBREW_PREFIX}/opt/
  ].freeze

  def unlinkapps_unlink?(target_app, opts = {})
    # Skip non-symlinks and symlinks that don't point into the Homebrew prefix.
    app = "#{target_app.readlink}" if target_app.symlink?
    return false unless app && app.start_with?(*UNLINKAPPS_PREFIXES)

    if opts.fetch(:prune, false)
      !File.exist?(app) # Remove only broken symlinks in prune mode.
    elsif ARGV.named.empty?
      true
    else
      ARGV.kegs.any? { |keg| app.start_with?("#{keg}/", "#{keg.opt_record}/") }
    end
  end
end
