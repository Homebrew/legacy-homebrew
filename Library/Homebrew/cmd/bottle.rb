require 'formula'
require 'bottles'
require 'tab'

module Homebrew extend self
  def bottle_formula f
    unless f.installed?
      return ofail "Formula not installed: #{f.name}"
      return
    end

    unless built_as_bottle? f
      return ofail "Formula not installed with '--build-bottle': #{f.name}"
    end

    bottle_version = bottle_new_version f
    filename = bottle_filename f, bottle_version
    bottle_path = Pathname.pwd/filename
    sha1 = nil

    HOMEBREW_CELLAR.cd do
      ohai "Bottling #{f.name} #{f.version}..."
      # Use gzip, faster to compress than bzip2, faster to uncompress than bzip2
      # or an uncompressed tarball (and more bandwidth friendly).
      safe_system 'tar', 'czf', bottle_path, "#{f.name}/#{f.version}"
      sha1 = bottle_path.sha1
      puts "./#{filename}"
      puts "bottle do"
      puts "  version #{bottle_version}" if bottle_version > 0
      puts "  sha1 '#{sha1}' => :#{MacOS.cat}"
      puts "end"
    end

    if ARGV.include? '--upload'
      safe_system 'scp', bottle_path, @scp_bottle
      FileUtils.mv bottle_path, HOMEBREW_CACHE
    end

    if ARGV.include? '--write'
      formula_path = HOMEBREW_REPOSITORY+"Library/Formula/#{f.name}.rb"
      inreplace formula_path do |s|
        if bottle_version > 1
          s.gsub!(/(\s+version\s+)\d+/, "\\1#{bottle_version}")
        end
        s.gsub!(/sha1(\s+')[0-9a-f]{40}('\s+=>\s+:(#{MacOS.cat}|#{MacOS.cat_without_underscores}))/,
                "sha1\\1#{sha1}\\2")
      end

      safe_system 'git', 'commit', formula_path, '-m',
        "#{f.name}: #{MacOS.cat} bottle."
    end
  end

  def bottle
    if ARGV.include? '--upload'
      sf_user = ENV['HOMEBREW_SOURCEFORGE_USERNAME']
      odie "No username" if sf_user.nil?
      @scp_bottle = "#{sf_user},machomebrew@frs.sourceforge.net:/home/frs/project/m/ma/machomebrew/Bottles"
    end

    ARGV.formulae.each do|f|
      bottle_formula Formula.factory f
    end
  end
end
