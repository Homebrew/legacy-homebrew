# Gets a patch from a GitHub commit or pull request and applies it to Homebrew.
# Optionally, installs it too.

require 'utils.rb'

if ARGV.include? '--install'
  ARGV.delete '--install'
  install = true
end

if ARGV.empty?
  puts 'This command requires at least one URL argument'
  exit 1
end

HOMEBREW_REPOSITORY.cd do
  ARGV.each do|arg|
    # This regex should work, if it's too precise, feel free to fix it.
    if !arg.match 'https:\/\/github.com\/\w+\/homebrew\/(pull\/\d+|commit\/\w{4,40})'
      ohai 'Ignoring URL:', "Not a GitHub pull request or commit: #{arg}"
      next
    end
    
    # GitHub provides commits'/pull-requests' raw patches using this URL.
    url = arg + '.patch'
    
    # The cache directory seems like a good place to put patches.
    patchpath = (HOMEBREW_CACHE+File.basename(url))
    curl url, '-o', patchpath
    
    # Makes sense to squash whitespace errors, we don't want them.
    ohai 'Applying patch'
    safe_system 'git', 'am', '--signoff', '--whitespace=fix', patchpath
    
    ohai 'Patch changed:'
    safe_system 'git', 'diff', 'HEAD~1', '--stat'
    
    if install
      status, filename = `git diff HEAD~1 --name-status`.split()
      # Don't try and do anything to removed files.
      if (status == 'A' or status == 'M') and filename.include? '/Formula/'
        formula = File.basename(filename, '.rb')
        ohai "Installing #{formula}"
        # Not sure if this is the best way to install?
        safe_system 'brew', 'install', '--force', formula
      end
    end
  end
end