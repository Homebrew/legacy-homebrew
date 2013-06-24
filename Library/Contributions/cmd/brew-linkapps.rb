# Links any Applications (.app) found in installed prefixes to ~/Applications
require 'keg'

TARGET_DIR = ARGV.include?("--system") ? "/Applications" : File.expand_path("~/Applications")

unless File.exist? TARGET_DIR
  opoo "#{TARGET_DIR} does not exist, stopping."
  puts "Run `mkdir #{TARGET_DIR}` first."
  exit 1
end

HOMEBREW_CELLAR.subdirs.each do |rack|
  kegs = rack.subdirs.map { |d| Keg.new(d) }
  next if kegs.empty?

  keg = kegs.detect(&:linked?) || kegs.max {|a,b| a.version <=> b.version}

  Dir["#{keg}/*.app", "#{keg}/bin/*.app", "#{keg}/libexec/*.app"].each do |app|
    puts "Linking #{app}"
    app_name = File.basename(app)
    target = "#{TARGET_DIR}/#{app_name}"

    if File.exist?(target) && File.symlink?(target)
      system "rm", target
    elsif File.exist?(target)
      onoe "#{target} already exists, skipping."
      next
    end
    system "ln", "-s", app, TARGET_DIR
  end
end

puts "Finished linking. Find the links under #{TARGET_DIR}."
