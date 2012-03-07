require 'blacklist'

module Homebrew extend self
  def hold
    # Make sure package exists
    ARGV.named.each do |name|
      msg = blacklisted? name
      raise "No available formula for #{name}\n#{msg}" if msg
    end unless ARGV.force?

    # Make sure Hold directory exists
    hold = HOMEBREW_REPOSITORY+'Library/Hold'
    if not File.exists? hold
      mkdir hold
    end

    hold_formulae ARGV.formulae
  end

  def hold_formulae formulae 
    formulae = [formulae].flatten.compact
    unless formulae.empty?
      formulae.each do |f|
        if f.installed_prefix.parent.children.length > 0
          if not File.exists? f.hold_path
            hold_this = nil
            Dir.entries(f.installed_prefix.parent).each do |n|
              hold_this = n if File.directory? n and n != '.' or n != '..'
            end
            hold_this = f.installed_prefix.parent+hold_this
            File.symlink(hold_this, f.hold_path)
            ohai "#{f.name} is now held"
          else
            ohai "#{f.name} is already held"
          end
        else
          ohai "#{f.name} is not installed and hence cannot be held"
        end
      end
    end
  end
end