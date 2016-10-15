# Original Inspiration: Stephen Benner https://github.com/SteveBenner: https://gist.github.com/SteveBenner/11254428
# Partially Rewritten by Dominyk Tiller https://github.com/DomT4 for Homebrew's internal use.
# THIS WILL COMPLETELY REMOVE HOMEBREW FROM YOUR SYSTEM

require "fileutils"
require "open3"
require "rubygems"

begin
  require "trollop"
rescue LoadError
  onoe "You must run `sudo /System/Library/Frameworks/Ruby.framework/Versions/Current/usr/bin/gem install trollop`"
  raise
end

module Homebrew
  def __selfdestruct

@options = Trollop::options do
  opt :quiet, "Run script with minimal user-visible output"
  opt :verbose, "Run script with maximum user-visible output"
  opt :dryrun, "Don't delete anything. Just show what would happen"
end

brew_location = HOMEBREW_PREFIX

brewlocal = %W{.git Cellar Library/brew.rb Library/Homebrew Library/Aliases Library/Formula Library/Contributions Library/ENV Library/LinkedKegs}
$files = []

# Found Homebrew installation
if brew_location
  unless @options[:quiet]
    puts "Homebrew found at: #{brew_location}"
    begin # record kegs and taps for later output
      brewed = `brew list`
      tapped = `brew tap`
    rescue StandardError
    end
  end
  # Collect files indexed by git
  begin
    Dir.chdir(brew_location) do
      # Update file list (use popen3 so we can suppress git error output)
      Open3.popen3('git checkout master') { |stdin, stdout, stderr| stderr.close }
      $files += `git ls-files`.split.map {|file| File.expand_path file }
    end
  rescue StandardError => e
    puts e
  end
end

# Collect files
$files += brewlocal.select { |file| File.exist? file }.map {|file| File.expand_path file }
cache = "#{HOMEBREW_CACHE}"
logs = "#{HOMEBREW_LOGS}"

abort 'Failed to locate any homebrew files!' if $files.empty?

rm =
  if @options[:dryrun]
    puts "Deleting #{cache}" unless @options[:quiet]
    puts "Deleting #{logs}" unless @options[:quiet]
    lambda { |entry| puts "deleting #{entry}" unless @options[:quiet] }
  else
    # Shelling out here enables us to get brew to do the heavy-lifting
    # around removing now-dead symlinks and directories.
    `brew list | pbcopy && brew remove $(pbpaste)`
    rm_rf cache
    rm_rf logs
    rm_rf HOMEBREW_PREFIX/"etc"
    lambda { |entry| FileUtils.rm_rf(entry, :verbose => @options[:verbose]) }
  end

puts 'Deleting files...' unless @options[:quiet]
$files.each(&rm)

# Print a list of formulae and kegs that were removed as part of the uninstall process
  if brewed
    puts
    puts 'The following previously installed formulae were removed:'
    puts brewed
  end

  if tapped
    puts
    puts 'The following previously tapped kegs were removed:'
    puts tapped
  end

  puts 'Homebrew has been removed from your system. Thanks for brewing with us!'
  puts 'You may also wish to revert your $PATH to its original state' unless @options[:quiet]
  end
end
