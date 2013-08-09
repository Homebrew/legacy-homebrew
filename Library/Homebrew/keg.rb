require 'extend/pathname'
require 'formula_lock'
require 'ostruct'

class Keg < Pathname
  def initialize path
    super path
    raise "#{to_s} is not a valid keg" unless parent.parent.realpath == HOMEBREW_CELLAR.realpath
    raise "#{to_s} is not a directory" unless directory?
  end

  # locale-specific directories have the form language[_territory][.codeset][@modifier]
  LOCALEDIR_RX = /(locale|man)\/([a-z]{2}|C|POSIX)(_[A-Z]{2})?(\.[a-zA-Z\-0-9]+(@.+)?)?/
  INFOFILE_RX = %r[info/([^.].*?\.info|dir)$]
  TOP_LEVEL_DIRECTORIES = %w[bin etc include lib sbin share var Frameworks]
  PRUNEABLE_DIRECTORIES = %w[bin etc include lib sbin share Frameworks LinkedKegs].map do |d|
    case d when 'LinkedKegs' then HOMEBREW_LIBRARY/d else HOMEBREW_PREFIX/d end
  end

  # if path is a file in a keg then this will return the containing Keg object
  def self.for path
    path = path.realpath
    while not path.root?
      return Keg.new(path) if path.parent.parent == HOMEBREW_CELLAR.realpath
      path = path.parent.realpath # realpath() prevents root? failing
    end
    raise NotAKegError, "#{path} is not inside a keg"
  end

  def uninstall
    rmtree
    parent.rmdir_if_possible
  end

  def unlink
    # these are used by the ObserverPathnameExtension to count the number
    # of files and directories linked
    $n=$d=0

    dirs = []

    TOP_LEVEL_DIRECTORIES.map{ |d| self/d }.each do |dir|
      next unless dir.exist?
      dir.find do |src|
        next if src == self
        dst = HOMEBREW_PREFIX + src.relative_path_from(self)
        dst.extend(ObserverPathnameExtension)

        dirs << dst if dst.directory? && !dst.symlink?

        # check whether the file to be unlinked is from the current keg first
        if !dst.symlink? || !dst.exist? || src != dst.resolved_path
          next
        end

        dst.uninstall_info if dst.to_s =~ INFOFILE_RX and ENV['HOMEBREW_KEEP_INFO']
        dst.unlink
        Find.prune if src.directory?
      end
    end
    linked_keg_record.unlink if linked_keg_record.symlink?

    dirs.reverse_each(&:rmdir_if_possible)

    $n+$d
  end

  def fname
    parent.basename.to_s
  end

  def lock
    FormulaLock.new(fname).with_lock { yield }
  end

  def linked_keg_record
    @linked_keg_record ||= HOMEBREW_REPOSITORY/"Library/LinkedKegs"/fname
  end

  def linked?
    linked_keg_record.directory? and self == linked_keg_record.realpath
  end

  def completion_installed? shell
    dir = case shell
      when :bash then self/'etc/bash_completion.d'
      when :zsh then self/'share/zsh/site-functions'
      end
    return if dir.nil?
    dir.directory? and not dir.children.length.zero?
  end

  def plist_installed?
    Dir.chdir self do
      not Dir.glob("*.plist").empty?
    end
  end

  def version
    require 'version'
    Version.new(basename.to_s)
  end

  def basename
    Pathname.new(self.to_s).basename
  end

  def link mode=OpenStruct.new
    raise "Cannot link #{fname}\nAnother version is already linked: #{linked_keg_record.realpath}" if linked_keg_record.directory?

    $n=0
    $d=0

    share_mkpaths = %w[aclocal doc info locale man]
    share_mkpaths.concat((1..8).map { |i| "man/man#{i}" })
    share_mkpaths.concat((1..8).map { |i| "man/cat#{i}" })
    # Paths used by Gnome Desktop support
    share_mkpaths.concat %w[applications gnome gnome/help icons mime-info pixmaps sounds]

    # yeah indeed, you have to force anything you need in the main tree into
    # these dirs REMEMBER that *NOT* everything needs to be in the main tree
    link_dir('etc', mode) {:mkpath}
    link_dir('bin', mode) {:skip_dir}
    link_dir('sbin', mode) {:skip_dir}
    link_dir('include', mode) {:link}

    link_dir('share', mode) do |path|
      case path.to_s
      when 'locale/locale.alias' then :skip_file
      when INFOFILE_RX then ENV['HOMEBREW_KEEP_INFO'] ? :info : :skip_file
      when LOCALEDIR_RX then :mkpath
      when *share_mkpaths then :mkpath
      when /^icons\/.*\/icon-theme\.cache$/ then :skip_file
      # all icons subfolders should also mkpath
      when /^icons\// then :mkpath
      when /^zsh/ then :mkpath
      else :link
      end
    end

    link_dir('lib', mode) do |path|
      case path.to_s
      when 'charset.alias' then :skip_file
      # pkg-config database gets explicitly created
      when 'pkgconfig' then :mkpath
      # lib/language folders also get explicitly created
      when /^gdk-pixbuf/ then :mkpath
      when 'ghc' then :mkpath
      when 'lua' then :mkpath
      when /^node/ then :mkpath
      when /^ocaml/ then :mkpath
      when /^perl5/ then :mkpath
      when 'php' then :mkpath
      when /^python[23]\.\d/ then :mkpath
      when 'ruby' then :mkpath
      # Everything else is symlinked to the cellar
      else :link
      end
    end

    link_dir('Frameworks', mode) do |path|
      # Frameworks contain symlinks pointing into a subdir, so we have to use
      # the :link strategy. However, for Foo.framework and
      # Foo.framework/Versions we have to use :mkpath so that multiple formulae
      # can link their versions into it and `brew [un]link` works.
      if path.to_s =~ /[^\/]*\.framework(\/Versions)?$/
        :mkpath
      else
        :link
      end
    end

    unless mode.dry_run
      linked_keg_record.make_relative_symlink(self)
      optlink
    end

    return $n + $d
  rescue Exception
    opoo "Could not link #{fname}. Unlinking..."
    unlink
    raise
  end

  def optlink
    from = HOMEBREW_PREFIX/:opt/fname
    if from.symlink?
      from.delete
    elsif from.directory?
      from.rmdir
    elsif from.exist?
      from.delete
    end
    from.make_relative_symlink(self)
  end

  protected

  def resolve_any_conflicts dst
    # if it isn't a directory then a severe conflict is about to happen. Let
    # it, and the exception that is generated will message to the user about
    # the situation
    if dst.symlink? and dst.directory?
      src = (dst.parent+dst.readlink).cleanpath
      keg = Keg.for(src)
      dst.unlink
      keg.link_dir(src) { :mkpath }
      return true
    end
  rescue NotAKegError
    puts "Won't resolve conflicts for symlink #{dst} as it doesn't resolve into the Cellar" if ARGV.verbose?
  end

  def make_relative_symlink dst, src, mode=OpenStruct.new
    if dst.exist? and dst.realpath == src.realpath
      puts "Skipping; already exists: #{dst}" if ARGV.verbose?
      return
    end

    # cf. git-clean -n: list files to delete, don't really link or delete
    if mode.dry_run and mode.overwrite
      if dst.symlink?
        puts "#{dst} -> #{dst.resolved_path}"
      elsif dst.exist?
        puts dst
      end
      return
    end

    # list all link targets
    if mode.dry_run
      puts dst
      return
    end

    dst.delete if mode.overwrite && (dst.exist? or dst.symlink?)
    dst.make_relative_symlink src
  end

  # symlinks the contents of self+foo recursively into #{HOMEBREW_PREFIX}/foo
  def link_dir foo, mode=OpenStruct.new
    root = self+foo
    return unless root.exist?
    root.find do |src|
      next if src == root
      dst = HOMEBREW_PREFIX+src.relative_path_from(self)
      dst.extend ObserverPathnameExtension

      if src.file?
        Find.prune if File.basename(src) == '.DS_Store'
        # Don't link pyc files because Python overwrites these cached object
        # files and next time brew wants to link, the pyc file is in the way.
        if src.extname.to_s == '.pyc' && src.to_s =~ /site-packages/
          Find.prune
        end

        case yield src.relative_path_from(root)
        when :skip_file, nil
          Find.prune
        when :info
          next if File.basename(src) == 'dir' # skip historical local 'dir' files
          make_relative_symlink dst, src, mode
          dst.install_info
        else
          make_relative_symlink dst, src, mode
        end
      elsif src.directory?
        # if the dst dir already exists, then great! walk the rest of the tree tho
        next if dst.directory? and not dst.symlink?
        # no need to put .app bundles in the path, the user can just use
        # spotlight, or the open command and actual mac apps use an equivalent
        Find.prune if src.extname.to_s == '.app'

        case yield src.relative_path_from(root)
        when :skip_dir
          Find.prune
        when :mkpath
          dst.mkpath unless resolve_any_conflicts(dst)
        else
          unless resolve_any_conflicts(dst)
            make_relative_symlink dst, src, mode
            Find.prune
          end
        end
      end
    end
  end
end

require 'keg_fix_install_names'
