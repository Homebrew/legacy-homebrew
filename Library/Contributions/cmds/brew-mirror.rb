require 'formula'

HOMEBREW_MIRROR_URL="https://downloads.sf.net/project/machomebrew/Mirrors"

sf_user = ENV['HOMEBREW_SOURCEFORGE_USERNAME']
odie "No username" if sf_user.nil?
scp_mirror = "#{sf_user},machomebrew@frs.sourceforge.net:/home/frs/project/m/ma/machomebrew/mirror"

ARGV.formulae.each do |f|
  path = f.fetch.first
  safe_system 'scp', path, scp_mirror
  formula_path = HOMEBREW_REPOSITORY+"Library/Formula/#{f.name}.rb"

  inreplace formula_path do |s|
    url = "#{HOMEBREW_MIRROR_URL}/#{path.basename}"
    s.gsub!(/url(\s+["']).*(["'])/, "url\\1#{url}\\2")
  end

  safe_system 'git', 'commit', formula_path, '-m',
    "#{f.name}: mirror on SourceForge."
end
