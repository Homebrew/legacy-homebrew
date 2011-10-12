# Gets a patch from a GitHub commit or pull request and applies it to Homebrew.
# Optionally, installs it too.

require 'utils.rb'

if ARGV.include? '--install'
  ARGV.delete '--install'
  install = true
end

if ARGV.empty?
  onoe 'This command requires at least one argument containing a URL or pull request number'
end

HOMEBREW_REPOSITORY.cd do
  ARGV.each do|arg|
    if arg.to_i > 0
      url = 'https://github.com/mxcl/homebrew/pull/' + arg + '.patch'
    else
      # This regex should work, if it's too precise, feel free to fix it.
      urlmatch = arg.match 'https:\/\/github.com\/\w+\/homebrew\/(pull\/(\d+)|commit\/\w{4,40})'
      if !urlmatch
        ohai 'Ignoring URL:', "Not a GitHub pull request or commit: #{arg}"
        next
      end

      # GitHub provides commits'/pull-requests' raw patches using this URL.
      url = urlmatch[0] + '.patch'
    end

    # The cache directory seems like a good place to put patches.
    HOMEBREW_CACHE.mkpath
    patchpath = (HOMEBREW_CACHE+File.basename(url))
    curl url, '-o', patchpath

    # Store current revision
    revision = `git log -n1 --format=%H`.strip()

    # Makes sense to squash whitespace errors, we don't want them.
    ohai 'Applying patch'
    safe_system 'git', 'am', '--signoff', '--whitespace=fix', patchpath

    issue = arg.to_i > 0 ? arg.to_i : urlmatch[2]
    if issue
      ohai "Patch closes issue ##{issue}"
      message = `git log HEAD^.. --format=%B`
      
      # If this is a pull request, append a close message.
      if !message.include? 'Closes #'
        issueline = "Closes ##{issue}."
        signed = 'Signed-off-by:'
        message = message.gsub signed, issueline + "\n\n" + signed
        safe_system 'git', 'commit', '--amend', '-q', '-m', message
      end
    end

    ohai 'Patch changed:'
    safe_system 'git', 'diff', "#{revision}..", '--stat'

    if install
      `git diff #{revision}.. --name-status`.each_line do |line|
        status, filename = line.split()
        # Don't try and do anything to removed files.
        if (status == 'A' or status == 'M') and filename.include? '/Formula/'
          formula = File.basename(filename, '.rb')
          ohai "Installing #{formula}"
          # Not sure if this is the best way to install?
          safe_system 'brew', 'install', '--force', '--build-from-source', formula
        end
      end
    end
  end
end
