# Automatically tests changed formulae

Dir.chdir HOMEBREW_REPOSITORY
branch = `git symbolic-ref -q HEAD`.chomp!
revisions = `git rev-list #{branch} ^origin/master`.chomp!
if revisions.nil?
  ohai "No commits to test!"
  exit
end

files = revisions.split.collect do |commit|
  `git diff-tree -r --no-commit-id --name-only #{commit}`.chomp!.split
end.flatten!

files.reject! {|file| !(file =~ /Library\/Formula/)}
opoo "No files were tested." if files.empty?

files.each do |file|
  exceptions = []
  source = HOMEBREW_REPOSITORY+file
  begin; require source.to_s
  rescue Exception
    exceptions << "#{Tty.yellow}Loading formula:#{Tty.reset} " + $!
  end
  begin; formula = Formula.factory source.stem
  rescue Exception
    exceptions << "#{Tty.yellow}Creating formula object:#{Tty.reset} " + $!
  end

  audit = `brew audit #{source.stem}`.chomp! if exceptions.empty?
  exceptions << "#{Tty.yellow}Audit failure:#{Tty.reset} " + audit.split("\n")[1..-2].join("\n") if audit

  [:options,:patches,:caveats].each do |option|
    begin; formula.send(option)
    rescue Exception
      exceptions << "#{Tty.yellow}#{option.to_s.capitalize}:#{Tty.reset} " + $!
    end
  end

  if !exceptions.empty?
    onoe "#{file} failed with the following exception(s):"
    puts exceptions
  end
end
