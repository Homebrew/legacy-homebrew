# Gets a patch from a GitHub commit or pull request and applies it to Homebrew.
# Optionally, installs it too.

require 'utils'

def tap arg
  match = arg.match(%r[homebrew-(\w+)/])
  match[1] if match
end

if ARGV.empty?
  onoe 'This command requires at least one argument containing a URL or pull request number'
end

ARGV.named.each do|arg|
  if arg.to_i > 0
    url = 'https://github.com/mxcl/homebrew/pull/' + arg
  else
    # This regex should work, if it's too precise, feel free to fix it.
    url_match = arg.match 'https:\/\/github.com\/\w+\/homebrew(-\w+)?\/(pull\/(\d+)|commit\/\w{4,40})'
    unless url_match
      ohai 'Ignoring URL:', "Not a GitHub pull request or commit: #{arg}"
      next
    end

    url = url_match[0]
  end

  if tap url
    Dir.chdir HOMEBREW_REPOSITORY/"Library/Taps/homebrew-#{tap url}"
  else
    Dir.chdir HOMEBREW_REPOSITORY
  end

  # GitHub provides commits'/pull-requests' raw patches using this URL.
  url += '.patch'

  # The cache directory seems like a good place to put patches.
  HOMEBREW_CACHE.mkpath
  patchpath = HOMEBREW_CACHE + File.basename(url)
  curl url, '-o', patchpath

  # Store current revision
  revision = `git rev-parse --short HEAD`.strip

  ohai 'Applying patch'
  patch_args = ['am']
  patch_args << '--signoff' unless ARGV.include? '--clean'
  # Normally we don't want whitespace errors, but squashing them can break
  # patches so an option is provided to skip this step.
  patch_args << '--whitespace=fix' unless ARGV.include? '--ignore-whitespace' or ARGV.include? '--clean'
  patch_args << patchpath

  safe_system 'git', *patch_args

  issue = arg.to_i > 0 ? arg.to_i : url_match[3]
  if issue and not ARGV.include? '--clean'
    ohai "Patch closes issue ##{issue}"
    message = `git log HEAD^.. --format=%B`

    # If this is a pull request, append a close message.
    unless message.include? 'Closes #'
      issueline = "Closes ##{issue}."
      signed = 'Signed-off-by:'
      message = message.gsub signed, issueline + "\n\n" + signed
      safe_system 'git', 'commit', '--amend', '-q', '-m', message
    end
  end

  ohai 'Patch changed:'
  safe_system 'git', 'diff', "#{revision}..", '--stat'

  if ARGV.include? '--install'
    `git diff #{revision}.. --name-status`.each_line do |line|
      status, filename = line.split
      # Don't try and do anything to removed files.
      if (status == 'A' or status == 'M') and filename.include? '/Formula/' or tap url
        formula = File.basename(filename, '.rb')
        ohai "Installing #{formula}"
        # Not sure if this is the best way to install?
        safe_system 'brew', 'install', '--force', '--build-bottle', formula
      end
    end
  end
end
