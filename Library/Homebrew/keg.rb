class Keg <Pathname
  def initialize path
    super path
    raise "#{to_s} is not a valid keg" unless parent.parent.realpath == HOMEBREW_CELLAR.realpath
    raise "#{to_s} is not a directory" unless directory?
  end

  class NotAKegError <RuntimeError; end

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
    chmod_R 0777 # ensure we have permission to delete
    rmtree
    parent.rmdir_if_possible
  end

  def unlink
    n=0
    Pathname.new(self).find do |src|
      next if src == self
      dst=HOMEBREW_PREFIX+src.relative_path_from(self)
      next unless dst.symlink?
      dst.unlink
      n+=1
      Find.prune if src.directory?
    end
    n
  end

  def link
    $n=0
    $d=0

    mkpaths=(1..9).collect {|x| "man/man#{x}"} <<'man'<<'doc'<<'locale'<<'info'<<'aclocal'

    # yeah indeed, you have to force anything you need in the main tree into
    # these dirs REMEMBER that *NOT* everything needs to be in the main tree
    link_dir('etc') {:mkpath}
    link_dir('bin') {:skip}
    link_dir('sbin') {:link}
    link_dir('include') {:link}
    link_dir('share') {|path| :mkpath if mkpaths.include? path.to_s}

    link_dir('lib') do |path|
      case path.to_s
      when /^pkgconfig/ then :mkpath
      when /^php/ then :mkpath
      when /^perl5/ then :mkpath
      when /^python2\.6/ then :mkpath
      end
    end

    return $n+$d
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

  # symlinks the contents of self+foo recursively into /usr/local/foo
  def link_dir foo
    root = self+foo
    return unless root.exist?

    root.find do |src|
      next if src == root

      dst = HOMEBREW_PREFIX+src.relative_path_from(self)
      dst.extend ObserverPathnameExtension

      if src.file?
        dst.make_relative_symlink src
      elsif src.directory?
        # if the dst dir already exists, then great! walk the rest of the tree tho
        next if dst.directory? and not dst.symlink?

        # no need to put .app bundles in the path, the user can just use
        # spotlight, or the open command and actual mac apps use an equivalent
        Find.prune if src.extname.to_s == '.app'

        case yield src.relative_path_from(root)
        when :skip
          Find.prune
        when :mkpath
          dst.mkpath unless resolve_any_conflicts(dst)
        else
          unless resolve_any_conflicts(dst)
            dst.make_relative_symlink(src)
            Find.prune
          end
        end
      end
    end
  end
end
