require 'extend/pathname'

REAL_CELLAR = HOMEBREW_CELLAR.realpath

class String
  def starts_with? prefix
    prefix = prefix.to_s
    self[0, prefix.length] == prefix
  end
end


def audit
  brew_links = Array.new
  version_map = Hash.new

  # paths=%w[bin sbin etc lib include share].collect {|d| HOMEBREW_PREFIX+d}
  paths=%w[bin].collect {|d| HOMEBREW_PREFIX+d}

  paths.each do |path|
    path.find do |path|
      next unless path.symlink? && path.resolved_path_exists?
      brew_links << Pathname.new(path.realpath)
    end
  end

  brew_links = brew_links.collect{|p|p.relative_path_from(REAL_CELLAR).to_s}.reject{|p|p.starts_with?("../")}
  brew_links.each do |p|
    parts = p.split("/")
    next if parts.count < 2 # Shouldn't happen
    brew = parts.shift
    version = parts.shift

    versions = version_map[brew] || []
    versions << version unless versions.include? version
    version_map[brew] = versions
  end

  return version_map
end

brews = audit
brews.keys.sort.each do |b|
  puts "#{b}: #{brews[b].sort*' '}"
end
puts
