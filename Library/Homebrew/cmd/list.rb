require 'formula'
require 'rack'
require 'keg'

module Homebrew extend self
  def list

    # Use of exec means we don't explicitly exit
    list_unbrewed if ARGV.flag? '--unbrewed'

    # Unbrewed uses the PREFIX, which will exist
    # Things below use the CELLAR, which doesn't until the first formula is installed.
    return unless HOMEBREW_CELLAR.exist?

    if ARGV.include?('--versions') || ARGV.named.empty?
      legend = []

      if ARGV.include? '--color'
        outdated = outdated_brews.map{ |b| b.name }
        linked   = Rack.linked_but_keg_only.map{ |r| r.fname }
        unlinked = Rack.unlinked_but_not_keg_only.map{ |r| r.fname }
        legend << "#{Tty.green}outdated#{Tty.reset}" unless outdated.empty?
        legend << "#{Tty.yellow_color}linked with --force#{Tty.reset}" unless linked.empty?
        legend << "#{Tty.red_color}unlinked#{Tty.reset}" unless unlinked.empty?
      else
        outdated = []
        linked = []
        unlinked = []
      end

      if ARGV.include? '--versions'
        name_and_versions = list_versions
        outdated = name_and_versions.select{ |f| outdated.include?(f[:name]) }
        linked   = name_and_versions.select{ |f| linked.include?(f[:name]) }
        unlinked = name_and_versions.select{ |f| unlinked.include?(f[:name]) }
        puts_columns( name_and_versions.map{ |f| "#{f[:name]} #{f[:versions]*' '}" },
                      :green=>outdated.map{ |f| "#{f[:name]} #{f[:versions]*' '}" },
                      :yellow=>linked.map{ |f| "#{f[:name]} #{f[:versions]*' '}" },
                      :red=>unlinked.map{ |f| "#{f[:name]} #{f[:versions]*' '}" } )
      elsif ARGV.named.empty?
        puts_columns( Rack.all_fnames,
                      :green=>outdated,
                      :yellow=>linked,
                      :red=>unlinked )
      end
      oh1 "Legend: " + legend.join(" - ") if !legend.empty? && $stdout.tty?
    elsif ARGV.verbose? || !$stdout.tty?
      exec "find", *ARGV.kegs + %w[-not -type d -print]
    else
      ARGV.kegs.each{ |keg| PrettyListing.new keg }
    end
  end

private

  def list_unbrewed
    dirs = HOMEBREW_PREFIX.children.select{ |pn| pn.directory? }.map{ |pn| pn.basename.to_s }
    dirs -= %w[Library Cellar .git]

    # Exclude the cache, if it has been located under the prefix
    cache_folder = (HOMEBREW_CACHE.relative_path_from(HOMEBREW_PREFIX)).to_s
    dirs -= [cache_folder]

    # Exclude the repository, if it has been located under the prefix
    cache_folder = (HOMEBREW_REPOSITORY.relative_path_from(HOMEBREW_PREFIX)).to_s
    dirs -= [cache_folder]

    cd HOMEBREW_PREFIX
    exec 'find', *dirs + %w[-type f ( ! -iname .ds_store ! -iname brew ! -iname brew-man.1 ! -iname brew.1 )]
  end

  def list_versions
    if ARGV.named.empty?
      HOMEBREW_CELLAR.children.select{ |pn| pn.directory? }
    else
      ARGV.named.map{ |n| HOMEBREW_CELLAR+n }.select{ |pn| pn.exist? }
    end.map do |d|
      versions = d.children.select{ |pn| pn.directory? }.map{ |pn| pn.basename.to_s }
      {:name=>d.basename.to_s, :versions=>versions}
    end
  end
end

class PrettyListing
  def initialize path
    Pathname.new(path).children.sort{ |a,b| a.to_s.downcase <=> b.to_s.downcase }.each do |pn|
      case pn.basename.to_s
      when 'bin', 'sbin'
        pn.find { |pnn| puts pnn unless pnn.directory? }
      when 'lib'
        print_dir pn do |pnn|
          # dylibs have multiple symlinks and we don't care about them
          (pnn.extname == '.dylib' or pnn.extname == '.pc') and not pnn.symlink?
        end
      else
        if pn.directory?
          if pn.symlink?
            puts "#{pn} -> #{pn.readlink}"
          else
            print_dir pn
          end
        elsif FORMULA_META_FILES.should_list? pn.basename.to_s
          puts pn
        end
      end
    end
  end

  def print_dir root
    dirs = []
    remaining_root_files = []
    other = ''

    root.children.sort.each do |pn|
      if pn.directory?
        dirs << pn
      elsif block_given? and yield pn
        puts pn
        other = 'other '
      else
        remaining_root_files << pn unless pn.basename.to_s == '.DS_Store'
      end
    end

    dirs.each do |d|
      files = []
      d.find { |pn| files << pn unless pn.directory? }
      print_remaining_files files, d
    end

    print_remaining_files remaining_root_files, root, other
  end

  def print_remaining_files files, root, other = ''
    case files.length
    when 0
      # noop
    when 1
      puts files
    else
      puts "#{root}/ (#{files.length} #{other}files)"
    end
  end
end
