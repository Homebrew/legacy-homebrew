require "keg"
require "formula"

module Homebrew
  def linkapps
    target_dir = linkapps_target(:local => ARGV.include?("--local"))

    unless target_dir.directory?
      opoo "#{target_dir} does not exist, stopping."
      puts "Run `mkdir #{target_dir}` first."
      exit 1
    end

    if ARGV.named.empty?
      kegs = Formula.racks.map do |rack|
        keg = rack.subdirs.map { |d| Keg.new(d) }
        next if keg.empty?
        keg.detect(&:linked?) || keg.max_by(&:version)
      end
    else
      kegs = ARGV.kegs
    end

    link_count = 0
    kegs.each do |keg|
      keg.apps.each do |app|
        puts "Linking: #{app}"
        target_app = target_dir/app.basename

        if target_app.exist? && !target_app.symlink?
          onoe "#{target_app} already exists, skipping."
          next
        end

        # We cannot use `install_symlink` because we want an absolute link.
        FileUtils.ln_sf(app, target_dir)
        link_count += 1
      end
    end

    if link_count.zero?
      puts "No apps linked to #{target_dir}" if ARGV.verbose?
    else
      puts "Linked #{link_count} app#{plural(link_count)} to #{target_dir}"
    end
  end

  private

  def linkapps_target(opts = {})
    local = opts.fetch(:local, false)
    Pathname.new(local ? "~/Applications" : "/Applications").expand_path
  end
end
