# Author: Stephen Benner https://github.com/SteveBenner
# Contributors: @AaronKulick
# THIS WILL COMPLETELY REMOVE HOMEBREW FROM YOUR SYSTEM

require 'optparse'
require 'fileutils'
require 'open3'

module Homebrew
  def __selfdestruct

unless options[:force]
  print "Completely remove Homebrew from your system? "
  abort unless gets.rstrip =~ /y|yes/i
end

$stdout.sync = true

# Default options
options = {
  :quiet     => false,
  :verbose   => true,
  :dry_run   => false,
  :force     => false,
  :find_path => false
}

optparser = OptionParser.new do |opts|
  opts.on('-q', '--quiet', 'Quiet mode - suppress output.') do |setting|
    options[:quiet]   = setting
    options[:verbose] = false
  end
  opts.on('-v', '--verbose', 'Verbose mode - print all operations.') { |setting| options[:verbose] = setting }
  opts.on('-d', '--dry', 'Dry run - print results, but perform no actual operations.') do |setting|
    options[:dry_run] = setting
  end
  opts.on('-f', '--force', 'Forces removal of files, bypassing prompt. USE WITH CAUTION!') do |setting|
    options[:force] = setting
  end
  opts.on('-p', '--find-path', 'Output homebrew location if found, then exit.') do |setting|
    options[:find_path] = setting
    options[:quiet]     = true
  end
  opts.on_tail('-h', '--help', '--usage', 'Display usage info and quit.') { puts opts; exit }
  opts.on_tail('--version', 'Display script version.') { puts opts.version; exit }
end
optparser.version = '0.1.2'
optparser.parse!

$quiet = options[:quiet]

# Files installed into the Homebrew repository
BREW_LOCAL_FILES = %w[
  .git
  Cellar
  Library/brew.rb
  Library/Homebrew
  Library/Aliases
  Library/Formula
  Library/Contributions
  Library/LinkedKegs
]
# Files that Homebrew installs into other system locations
BREW_SYSTEM_FILES = %W[
  #{ENV['HOME']}/Library/Caches/Homebrew
  #{ENV['HOME']}/Library/Logs/Homebrew
  /Library/Caches/Homebrew
]
$files = []

# This function runs given command in a sub-shell, expecting the output to be the
# path of a Homebrew installation. If given a block, it passes the shell output to
# the block for processing, using the return value of the block as the new path.
# Known Homebrew files are then scanned for and added to the file list. Then the
# directory is tested for a Homebrew installation, and the git index is added if
# a valid repo is found. The function won't run once a Homebrew installation is
# found, but it will accumulate untracked Homebrew files each invocation.
#
# @param  [String] cmd        A shell command to run
# @param  [String] error_msg  Message to print if command fails
#
def locate_brew_path(cmd, error_msg = 'check homebrew installation and PATH.')
  return if $brew_location # stop testing if we find a valid Homebrew installation
  puts "Searching for homewbrew installation using '#{cmd}'..." unless $quiet

  # Run given shell command along with any code passed-in via block
  path = `#{cmd}`.chomp
  path = yield(path) if block_given? # pass command output to your own fancy code block

  begin
    Dir.chdir(path) do
      # Search for known Homebrew files and folders, regardless of git presence
      $files += BREW_LOCAL_FILES.select { |file| File.exist? file }.map {|file| File.expand_path file }
      $files += Dir.glob('**/{man,bin}/**/brew*')
      # Test for Homebrew git repository (use popen3 so we can suppress git error output)
      repo_name = Open3.popen3('git remote -v') do |stdin, stdout, stderr|
        stderr.close
        stdout.read
      end
      if repo_name =~ /homebrew.git|Homebrew/
        $brew_location = path
      else
        return
      end
    end
  rescue StandardError # on normal errors, continue program
    return
  end
end

# Attempt to locate homebrew installation using a command and optional code block
# for processing the command results. Locating a valid path halts searching.
locate_brew_path 'brew --prefix'
locate_brew_path('which brew') { |output| File.expand_path('../..', output) }
locate_brew_path('command -v brew') { |output| File.expand_path('../..', output) }
locate_brew_path 'brew --prefix' do |output|
  output = output.split($/).first
  File.expand_path('../..', output)
end

# Found Homebrew installation
if $brew_location
  if options[:find_path]
    puts $brew_location
    exit
  end
  unless options[:quiet]
    puts "Homebrew found at: #{$brew_location}"
    begin # record kegs and taps for later output
      brewed = `brew list`
      tapped = `brew tap`
    rescue StandardError
    end
  end
  # Collect files indexed by git
  begin
    Dir.chdir($brew_location) do
      # Update file list (use popen3 so we can suppress git error output)
      Open3.popen3('git checkout master') { |stdin, stdout, stderr| stderr.close }
      $files += `git ls-files`.split.map {|file| File.expand_path file }
    end
  rescue StandardError => e
    puts e # Report any errors, but continue the script and collect any last files
  end
end

# Collect any files Homebrew may have installed throughout our system
$files += BREW_SYSTEM_FILES.select { |file| File.exist? file }

abort 'Failed to locate any homebrew files!' if $files.empty?

# DESTROY! DESTROY! DESTROY!
unless options[:force]
  print "Delete #{$files.count} files? "
  abort unless gets.rstrip =~ /y|yes/i
end

rm =
  if options[:dry_run]
    lambda { |entry| puts "deleting #{entry}" unless options[:quiet] }
  else
    lambda { |entry| FileUtils.rm_rf(entry, :verbose => options[:verbose]) }
  end

puts 'Deleting files...' unless options[:quiet]
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
puts 'You may also wish to revert your $PATH to its original state' unless options[:quiet]
  end
end
