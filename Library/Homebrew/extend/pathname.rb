require 'pathname'
require 'mach'

# we enhance pathname to make our code more readable
class Pathname
  include MachO

  BOTTLE_EXTNAME_RX = /(\.[a-z_]+(32)?\.bottle\.(\d+\.)?tar\.gz)$/

  def install *sources
    results = []
    sources.each do |src|
      case src
      when Array
        if src.empty?
          opoo "tried to install empty array to #{self}"
          return []
        end
        src.each {|s| results << install_p(s) }
      when Hash
        if src.empty?
          opoo "tried to install empty hash to #{self}"
          return []
        end
        src.each {|s, new_basename| results << install_p(s, new_basename) }
      else
        results << install_p(src)
      end
    end
    return results
  end

  def install_p src, new_basename = nil
    if new_basename
      new_basename = File.basename(new_basename) # rationale: see Pathname.+
      dst = self+new_basename
      return_value = Pathname.new(dst)
    else
      dst = self
      return_value = self+File.basename(src)
    end

    src = src.to_s
    dst = dst.to_s

    # if it's a symlink, don't resolve it to a file because if we are moving
    # files one by one, it's likely we will break the symlink by moving what
    # it points to before we move it
    # and also broken symlinks are not the end of the world
    raise "#{src} does not exist" unless File.symlink? src or File.exist? src

    mkpath
    if File.symlink? src
      # we use the BSD mv command because FileUtils copies the target and
      # not the link! I'm beginning to wish I'd used Python quite honestly!
      raise unless Kernel.system 'mv', src, dst
    else
      # we mv when possible as it is faster and you should only be using
      # this function when installing from the temporary build directory
      FileUtils.mv src, dst
    end

    return return_value
  end
  protected :install_p

  # Creates symlinks to sources in this folder.
  def install_symlink *sources
    results = []
    sources.each do |src|
      case src
      when Array
        src.each {|s| results << install_symlink_p(s) }
      when Hash
        src.each {|s, new_basename| results << install_symlink_p(s, new_basename) }
      else
        results << install_symlink_p(src)
      end
    end
    return results
  end

  def install_symlink_p src, new_basename = nil
    if new_basename.nil?
      dst = self+File.basename(src)
    else
      dst = self+File.basename(new_basename)
    end

    src = src.to_s
    dst = dst.to_s

    mkpath
    FileUtils.ln_s src, dst

    return dst
  end
  protected :install_symlink_p

  # we assume this pathname object is a file obviously
  def write content
    raise "Will not overwrite #{to_s}" if exist? and not ARGV.force?
    dirname.mkpath
    File.open(self, 'w') {|f| f.write content }
  end

  # NOTE always overwrites
  def atomic_write content
    require 'tempfile'
    tf = Tempfile.new(self.basename.to_s)
    tf.write(content)
    tf.close
    FileUtils.mv tf.path, self.to_s
  end

  def cp dst
    if file?
      FileUtils.cp to_s, dst
    else
      FileUtils.cp_r to_s, dst
    end
    return dst
  end

  # extended to support common double extensions
  alias extname_old extname
  def extname(path=to_s)
    BOTTLE_EXTNAME_RX.match(path)
    return $1 if $1
    /(\.(tar|cpio)\.(gz|bz2|xz|Z))$/.match(path)
    return $1 if $1
    return File.extname(path)
  end

  # for filetypes we support, basename without extension
  def stem
    File.basename((path = to_s), extname(path))
  end

  # I don't trust the children.length == 0 check particularly, not to mention
  # it is slow to enumerate the whole directory just to see if it is empty,
  # instead rely on good ol' libc and the filesystem
  def rmdir_if_possible
    rmdir
    true
  rescue Errno::ENOTEMPTY
    if (ds_store = self+'.DS_Store').exist? && children.length == 1
      ds_store.unlink
      retry
    else
      false
    end
  rescue Errno::EACCES, Errno::ENOENT
    false
  end

  def chmod_R perms
    require 'fileutils'
    FileUtils.chmod_R perms, to_s
  end

  def abv
    out=''
    n=`find #{to_s} -type f ! -name .DS_Store | wc -l`.to_i
    out<<"#{n} files, " if n > 1
    out<<`/usr/bin/du -hs #{to_s} | cut -d"\t" -f1`.strip
  end

  def version
    require 'version'
    Version.parse(self)
  end

  def compression_type
    # Don't treat jars or wars as compressed
    return nil if self.extname == '.jar'
    return nil if self.extname == '.war'

    # OS X installer package
    return :pkg if self.extname == '.pkg'

    # If the filename ends with .gz not preceded by .tar
    # then we want to gunzip but not tar
    return :gzip_only if self.extname == '.gz'

    # Get enough of the file to detect common file types
    # POSIX tar magic has a 257 byte offset
    # magic numbers stolen from /usr/share/file/magic/
    case open { |f| f.read(262) }
    when /^PK\003\004/n         then :zip
    when /^\037\213/n           then :gzip
    when /^BZh/n                then :bzip2
    when /^\037\235/n           then :compress
    when /^.{257}ustar/n        then :tar
    when /^\xFD7zXZ\x00/n       then :xz
    when /^Rar!/n               then :rar
    when /^7z\xBC\xAF\x27\x1C/n then :p7zip
    else
      # This code so that bad-tarballs and zips produce good error messages
      # when they don't unarchive properly.
      case extname
      when ".tar.gz", ".tgz", ".tar.bz2", ".tbz" then :tar
      when ".zip" then :zip
      end
    end
  end

  def text_executable?
    %r[^#!\s*\S+] === open('r') { |f| f.read(1024) }
  end

  def incremental_hash(hasher)
    incr_hash = hasher.new
    self.open('r') do |f|
      while(buf = f.read(1024))
        incr_hash << buf
      end
    end
    incr_hash.hexdigest
  end

  def sha1
    require 'digest/sha1'
    incremental_hash(Digest::SHA1)
  end

  def sha2
    require 'digest/sha2'
    incremental_hash(Digest::SHA2)
  end
  alias_method :sha256, :sha2

  def verify_checksum expected
    raise ChecksumMissingError if expected.nil? or expected.empty?
    actual = Checksum.new(expected.hash_type, send(expected.hash_type).downcase)
    raise ChecksumMismatchError.new(expected, actual) unless expected == actual
  end

  if '1.9' <= RUBY_VERSION
    alias_method :to_str, :to_s
  end

  def cd
    Dir.chdir(self){ yield }
  end

  def subdirs
    children.select{ |child| child.directory? }
  end

  def resolved_path
    self.symlink? ? dirname+readlink : self
  end

  def resolved_path_exists?
    link = readlink
  rescue ArgumentError
    # The link target contains NUL bytes
    false
  else
    (dirname+link).exist?
  end

  # perhaps confusingly, this Pathname object becomes the symlink pointing to
  # the src paramter.
  def make_relative_symlink src
    src = Pathname.new(src) unless src.kind_of? Pathname

    self.dirname.mkpath
    Dir.chdir self.dirname do
      # NOTE only system ln -s will create RELATIVE symlinks
      quiet_system 'ln', '-s', src.relative_path_from(self.dirname), self.basename
      if not $?.success?
        if self.exist?
          raise <<-EOS.undent
            Could not symlink file: #{src.expand_path}
            Target #{self} already exists. You may need to delete it.
            To force the link and overwrite all other conflicting files, do:
              brew link --overwrite formula_name

            To list all files that would be deleted:
              brew link --overwrite --dry-run formula_name
            EOS
        # #exist? will return false for symlinks whose target doesn't exist
        elsif self.symlink?
          raise <<-EOS.undent
            Could not symlink file: #{src.expand_path}
            Target #{self} already exists as a symlink to #{readlink}.
            If this file is from another formula, you may need to
            `brew unlink` it. Otherwise, you may want to delete it.
            To force the link and overwrite all other conflicting files, do:
              brew link --overwrite formula_name

            To list all files that would be deleted:
              brew link --overwrite --dry-run formula_name
            EOS
        elsif !dirname.writable_real?
          raise <<-EOS.undent
            Could not symlink file: #{src.expand_path}
            #{dirname} is not writable. You should change its permissions.
            EOS
        else
          raise <<-EOS.undent
            Could not symlink file: #{src.expand_path}
            #{self} may already exist.
            #{dirname} may not be writable.
            EOS
        end
      end
    end
  end

  def / that
    join that.to_s
  end

  def ensure_writable
    saved_perms = nil
    unless writable_real?
      saved_perms = stat.mode
      chmod 0644
    end
    yield
  ensure
    chmod saved_perms if saved_perms
  end

  def install_info
    unless self.symlink?
      raise "Cannot install info entry for unbrewed info file '#{self}'"
    end
    system '/usr/bin/install-info', '--quiet', self.to_s, (self.dirname+'dir').to_s
  end

  def uninstall_info
    unless self.symlink?
      raise "Cannot uninstall info entry for unbrewed info file '#{self}'"
    end
    system '/usr/bin/install-info', '--delete', '--quiet', self.to_s, (self.dirname+'dir').to_s
  end

  def all_formula pwd = self
    children.map{ |child| child.relative_path_from(pwd) }.each do |pn|
      yield pn if pn.to_s =~ /.rb$/
    end
    children.each do |child|
      child.all_formula(pwd) do |pn|
        yield pn
      end if child.directory?
    end
  end

  def find_formula
    [self/:Formula, self/:HomebrewFormula, self].each do |d|
      if d.exist?
        d.children.map{ |child| child.relative_path_from(self) }.each do |pn|
          yield pn if pn.to_s =~ /.rb$/
        end
        break
      end
    end
  end

  # Writes an exec script in this folder for each target pathname
  def write_exec_script *targets
    targets.flatten!
    if targets.empty?
      opoo "tried to write exec scripts to #{self} for an empty list of targets"
    end
    targets.each do |target|
      target = Pathname.new(target) # allow pathnames or strings
      (self+target.basename()).write <<-EOS.undent
      #!/bin/bash
      exec "#{target}" "$@"
      EOS
    end
  end

  # Writes an exec script that invokes a java jar
  def write_jar_script target_jar, script_name, java_opts=""
    (self+script_name).write <<-EOS.undent
    #!/bin/bash
    exec java #{java_opts} -jar #{target_jar} "$@"
    EOS
  end

  def install_metafiles from=nil
    # Default to current path, and make sure we have a pathname, not a string
    from = "." if from.nil?
    from = Pathname.new(from.to_s)

    from.children.each do |p|
      next if p.directory?
      next unless FORMULA_META_FILES.should_copy? p
      # Some software symlinks these files (see help2man.rb)
      filename = p.resolved_path
      # Some software links metafiles together, so by the time we iterate to one of them
      # we may have already moved it. libxml2's COPYING and Copyright are affected by this.
      next unless filename.exist?
      filename.chmod 0644
      self.install filename
    end
  end

  # We redefine these private methods in order to add the /o modifier to
  # the Regexp literals, which forces string interpolation to happen only
  # once instead of each time the method is called. This is fixed in 1.9+.
  if RUBY_VERSION <= "1.8.7"
    alias_method :old_chop_basename, :chop_basename
    def chop_basename(path)
      base = File.basename(path)
      if /\A#{Pathname::SEPARATOR_PAT}?\z/o =~ base
        return nil
      else
        return path[0, path.rindex(base)], base
      end
    end
    private :chop_basename

    alias_method :old_prepend_prefix, :prepend_prefix
    def prepend_prefix(prefix, relpath)
      if relpath.empty?
        File.dirname(prefix)
      elsif /#{SEPARATOR_PAT}/o =~ prefix
        prefix = File.dirname(prefix)
        prefix = File.join(prefix, "") if File.basename(prefix + 'a') != 'a'
        prefix + relpath
      else
        prefix + relpath
      end
    end
    private :prepend_prefix
  end
end

# sets $n and $d so you can observe creation of stuff
module ObserverPathnameExtension
  def unlink
    super
    puts "rm #{to_s}" if ARGV.verbose?
    $n+=1
  end
  def rmdir
    super
    puts "rmdir #{to_s}" if ARGV.verbose?
    $d+=1
  end
  def make_relative_symlink src
    super
    $n+=1
  end
  def install_info
    super
    puts "info #{to_s}" if ARGV.verbose?
  end
  def uninstall_info
    super
    puts "uninfo #{to_s}" if ARGV.verbose?
  end
end

$n=0
$d=0
