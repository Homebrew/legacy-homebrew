require 'formula'

module Homebrew extend self
  def info
    if ARGV.named.empty?
      if ARGV.include? "--all"
        Formula.each do |f|
          info_formula f
          puts '---'
        end
      else
        puts "#{HOMEBREW_CELLAR.children.length} kegs, #{HOMEBREW_CELLAR.abv}"
      end
    elsif valid_url ARGV[0]
      info_formula Formula.factory(ARGV.shift)
    else
      ARGV.formulae.each{ |f| info_formula f }
    end
  end

  def github_info name
    formula_name = Formula.path(name).basename
    user = 'mxcl'
    branch = 'master'

    if system "/usr/bin/which -s git"
      gh_user=`git config --global github.user 2>/dev/null`.chomp
      /^\*\s*(.*)/.match(`git --work-tree=#{HOMEBREW_REPOSITORY} branch 2>/dev/null`)
      unless $1.nil? || $1.empty? || gh_user.empty?
        branch = $1.chomp
        user = gh_user
      end
    end

    "http://github.com/#{user}/homebrew/commits/#{branch}/Library/Formula/#{formula_name}"
  end

  def info_formula f
    exec 'open', github_info(f.name) if ARGV.flag? '--github'

    puts "#{f.name} #{f.version}"
    puts f.homepage

    puts "Depends on: #{f.deps*', '}" unless f.deps.empty?

    rack = f.prefix.parent
    if rack.directory?
      kegs = rack.children
      kegs.each do |keg|
        next if keg.basename.to_s == '.DS_Store'
        print "#{keg} (#{keg.abv})"
        print " *" if f.installed_prefix == keg and kegs.length > 1
        puts
      end
    else
      puts "Not installed"
    end

    if f.caveats
      puts
      puts f.caveats
      puts
    end

    history = github_info f.name
    puts history if history

  rescue FormulaUnavailableError
    # check for DIY installation
    d = HOMEBREW_PREFIX+name
    if d.directory?
      ohai "DIY Installation"
      d.children.each{ |keg| puts "#{keg} (#{keg.abv})" }
    else
      raise "No such formula or keg"
    end
  end

  private

  def valid_url u
    u[0..6] == 'http://' or u[0..7] == 'https://' or u[0..5] == 'ftp://'
  end

end
