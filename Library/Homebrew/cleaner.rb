# Cleans a newly installed keg.
# By default:
# * removes .la files
# * removes empty directories
# * sets permissions on executables
# * removes unresolved symlinks
class Cleaner

  # Create a cleaner for the given formula
  def initialize f
    @f = f
  end

  # Clean the keg of formula @f
  def clean
    ObserverPathnameExtension.reset_counts!

    # Many formulae include 'lib/charset.alias', but it is not strictly needed
    # and will conflict if more than one formula provides it
    observe_file_removal @f.lib/'charset.alias'

    [@f.bin, @f.sbin, @f.lib].select{ |d| d.exist? }.each{ |d| clean_dir d }

    # Get rid of any info 'dir' files, so they don't conflict at the link stage
    info_dir_file = @f.info + 'dir'
    if info_dir_file.file? and not @f.skip_clean? info_dir_file
      observe_file_removal info_dir_file
    end

    prune
  end

  private

  def observe_file_removal path
    path.extend(ObserverPathnameExtension).unlink if path.exist?
  end

  # Removes any empty directories in the formula's prefix subtree
  # Keeps any empty directions projected by skip_clean
  # Removes any unresolved symlinks
  def prune
    dirs = []
    symlinks = []
    @f.prefix.find do |path|
      if @f.skip_clean? path
        Find.prune
      elsif path.symlink?
        symlinks << path
      elsif path.directory?
        dirs << path
      end
    end

    # Remove directories opposite from traversal, so that a subtree with no
    # actual files gets removed correctly.
    dirs.reverse_each do |d|
      if d.children.empty?
        puts "rmdir: #{d} (empty)" if ARGV.verbose?
        d.rmdir
      end
    end

    # Remove unresolved symlinks
    symlinks.reverse_each do |s|
      s.unlink unless s.resolved_path_exists?
    end
  end

  # Clean a top-level (bin, sbin, lib) directory, recursively, by fixing file
  # permissions and removing .la files, unless the files (or parent
  # directories) are protected by skip_clean.
  #
  # bin and sbin should not have any subdirectories; if either do that is
  # caught as an audit warning
  #
  # lib may have a large directory tree (see Erlang for instance), and
  # clean_dir applies cleaning rules to the entire tree
  def clean_dir d
    d.find do |path|
      path.extend(ObserverPathnameExtension)

      Find.prune if @f.skip_clean? path

      if path.symlink? or path.directory?
        next
      elsif path.extname == '.la'
        path.unlink
      else
        # Set permissions for executables and non-executables
        perms = if path.mach_o_executable? || path.text_executable?
                  0555
                else
                  0444
                end
        if ARGV.debug?
          old_perms = path.stat.mode & 0777
          if perms != old_perms
            puts "Fixing #{path} permissions from #{old_perms.to_s(8)} to #{perms.to_s(8)}"
          end
        end
        path.chmod perms
      end
    end
  end

end
