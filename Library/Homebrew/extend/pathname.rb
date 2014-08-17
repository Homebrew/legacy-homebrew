require 'pathname'
require 'mach'
require 'resource'
require 'metafiles'

# we enhance pathname to make our code more readable
class Pathname
  include MachO

  BOTTLE_EXTNAME_RX = /(\.[a-z_]+(32)?\.bottle\.(\d+\.)?tar\.gz)$/

  def install *sources
    sources.each do |src|
      case src
      when Resource
        src.stage(self)
      when Resource::Partial
        src.resource.stage { install(*src.files) }
      when Array
        if src.empty?
          opoo "tried to install empty array to #{self}"
          return
        end
        src.each {|s| install_p(s) }
      when Hash
        if src.empty?
          opoo "tried to install empty hash to #{self}"
          return
        end
        src.each {|s, new_basename| install_p(s, new_basename) }
      else
        install_p(src)
      end
    end
  end

  def install_p src, new_basename = nil
    raise Errno::ENOENT, src.to_s unless File.symlink?(src) || File.exist?(src)

    if new_basename
      new_basename = File.basename(new_basename) # rationale: see Pathname.+
      dst = self+new_basename
    else
      dst = self
    end

    src = src.to_s
    dst = dst.to_s

    dst = yield(src, dst) if block_given?

    mkpath

    # Use FileUtils.mv over File.rename to handle filesystem boundaries. If src
    # is a symlink, and its target is moved first, FileUtils.mv will fail:
    #   https://bugs.ruby-lang.org/issues/7707
    # In that case, use the system "mv" command.
    if File.symlink? src
      raise unless Kernel.system 'mv', src, dst
    else
      FileUtils.mv src, dst
    end
  end
  protected :install_p

  # Creates symlinks to sources in this folder.
  def install_symlink *sources
    sources.each do |src|
      case src
      when Array
        src.each {|s| install_symlink_p(s) }
      when Hash
        src.each {|s, new_basename| install_symlink_p(s, new_basename) }
      else
        install_symlink_p(src)
      end
    end
  end

  def install_symlink_p src, new_basename=src
    src = Pathname(src).expand_path(self)
    dst = join File.basename(new_basename)
    mkpath
    FileUtils.ln_sf src.relative_path_from(dst.parent), dst
  end
  protected :install_symlink_p

  # we assume this pathname object is a file obviously
  alias_method :old_write, :write if method_defined?(:write)
  def write(content, *open_args)
    raise "Will not overwrite #{to_s}" if exist?
    dirname.mkpath
    open("w", *open_args) { |f| f.write(content) }
  end

  def binwrite(contents, *open_args)
    open("wb", *open_args) { |f| f.write(contents) }
  end unless method_defined?(:binwrite)

  def binread(*open_args)
    open("rb", *open_args) { |f| f.read }
  end unless method_defined?(:binread)

  # NOTE always overwrites
  def atomic_write content
    require "tempfile"
    tf = Tempfile.new(basename.to_s)
    tf.binmode
    tf.write(content)
    tf.close

    begin
      old_stat = stat
    rescue Errno::ENOENT
      old_stat = default_stat
    end

    FileUtils.mv tf.path, self

    uid = Process.uid
    gid = Process.groups.delete(old_stat.gid) { Process.gid }

    begin
      chown(uid, gid)
      chmod(old_stat.mode)
    rescue Errno::EPERM
    end
  end

  def default_stat
    sentinel = parent.join(".brew.#{Process.pid}.#{rand(Time.now.to_i)}")
    sentinel.open("w") { }
    sentinel.stat
  ensure
    sentinel.unlink
  end
  private :default_stat

  def cp dst
    opoo "Pathname#cp is deprecated, use FileUtils.cp"
    if file?
      FileUtils.cp to_s, dst
    else
      FileUtils.cp_r to_s, dst
    end
    return dst
  end

  def cp_path_sub pattern, replacement
    raise "#{self} does not exist" unless self.exist?

    src = self.to_s
    dst = src.sub(pattern, replacement)
    raise "#{src} is the same file as #{dst}" if src == dst

    dst_path = Pathname.new dst

    if self.directory?
      dst_path.mkpath
      return
    end

    dst_path.dirname.mkpath

    dst = yield(src, dst) if block_given?

    FileUtils.cp(src, dst)
  end

  # extended to support common double extensions
  alias extname_old extname
  def extname(path=to_s)
    BOTTLE_EXTNAME_RX.match(path)
    return $1 if $1
    /(\.(tar|cpio|pax)\.(gz|bz2|lz|xz|Z))$/.match(path)
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
    opoo "Pathname#chmod_R is deprecated, use FileUtils.chmod_R"
    require 'fileutils'
    FileUtils.chmod_R perms, to_s
  end

  def version
    require 'version'
    Version.parse(self)
  end

  def compression_type
    case extname
    when ".jar", ".war"
      # Don't treat jars or wars as compressed
      return
    when ".gz"
      # If the filename ends with .gz not preceded by .tar
      # then we want to gunzip but not tar
      return :gzip_only
    when ".bz2"
      return :bzip2_only
    end

    # Get enough of the file to detect common file types
    # POSIX tar magic has a 257 byte offset
    # magic numbers stolen from /usr/share/file/magic/
    case open('rb') { |f| f.read(262) }
    when /^PK\003\004/n         then :zip
    when /^\037\213/n           then :gzip
    when /^BZh/n                then :bzip2
    when /^\037\235/n           then :compress
    when /^.{257}ustar/n        then :tar
    when /^\xFD7zXZ\x00/n       then :xz
    when /^LZIP/n               then :lzip
    when /^Rar!/n               then :rar
    when /^7z\xBC\xAF\x27\x1C/n then :p7zip
    when /^xar!/n               then :xar
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

  def incremental_hash(klass)
    digest = klass.new
    if digest.respond_to?(:file)
      digest.file(self)
    else
      buf = ""
      open("rb") { |f| digest << buf while f.read(1024, buf) }
    end
    digest.hexdigest
  end

  def sha1
    require 'digest/sha1'
    incremental_hash(Digest::SHA1)
  end

  def sha256
    require 'digest/sha2'
    incremental_hash(Digest::SHA2)
  end

  def verify_checksum expected
    raise ChecksumMissingError if expected.nil? or expected.empty?
    actual = Checksum.new(expected.hash_type, send(expected.hash_type).downcase)
    raise ChecksumMismatchError.new(self, expected, actual) unless expected == actual
  end

  # FIXME eliminate the places where we rely on this method
  alias_method :to_str, :to_s unless method_defined?(:to_str)

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

  def make_relative_symlink(src)
    dirname.mkpath
    File.symlink(src.relative_path_from(dirname), self)
  end

  def /(other)
    unless other.respond_to?(:to_str) || other.respond_to?(:to_path)
      opoo "Pathname#/ called on #{inspect} with #{other.inspect} as an argument"
      puts "This behavior is deprecated, please pass either a String or a Pathname"
    end
    self + other.to_s
  end unless method_defined?(:/)

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
    quiet_system "/usr/bin/install-info", "--quiet", to_s, "#{dirname}/dir"
  end

  def uninstall_info
    quiet_system "/usr/bin/install-info", "--delete", "--quiet", to_s, "#{dirname}/dir"
  end

  def find_formula
    [join("Formula"), join("HomebrewFormula"), self].each do |d|
      if d.exist?
        d.children.each do |pn|
          yield pn if pn.extname == ".rb"
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
      return
    end
    mkpath
    targets.each do |target|
      target = Pathname.new(target) # allow pathnames or strings
      (self+target.basename()).write <<-EOS.undent
        #!/bin/bash
        exec "#{target}" "$@"
      EOS
    end
  end

  # Writes an exec script that sets environment variables
  def write_env_script target, env
    env_export = ''
    env.each {|key, value| env_export += "#{key}=\"#{value}\" "}
    dirname.mkpath
    self.write <<-EOS.undent
    #!/bin/bash
    #{env_export}exec "#{target}" "$@"
    EOS
  end

  # Writes a wrapper env script and moves all files to the dst
  def env_script_all_files dst, env
    dst.mkpath
    Pathname.glob("#{self}/*") do |file|
      dst.install_p file
      new_file = dst+file.basename
      file.write_env_script(new_file, env)
    end
  end

  # Writes an exec script that invokes a java jar
  def write_jar_script target_jar, script_name, java_opts=""
    mkpath
    (self+script_name).write <<-EOS.undent
      #!/bin/bash
      exec java #{java_opts} -jar #{target_jar} "$@"
    EOS
  end

  def install_metafiles from=Pathname.pwd
    Pathname(from).children.each do |p|
      next if p.directory?
      next unless Metafiles.copy?(p.basename.to_s)
      # Some software symlinks these files (see help2man.rb)
      filename = p.resolved_path
      # Some software links metafiles together, so by the time we iterate to one of them
      # we may have already moved it. libxml2's COPYING and Copyright are affected by this.
      next unless filename.exist?
      filename.chmod 0644
      install(filename)
    end
  end

  def abv
    out=''
    n=`find #{to_s} -type f ! -name .DS_Store | wc -l`.to_i
    out << "#{n} files, " if n > 1
    out << `/usr/bin/du -hs #{to_s} | cut -d"\t" -f1`.strip
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
  elsif RUBY_VERSION == "2.0.0"
    # https://bugs.ruby-lang.org/issues/9915
    prepend Module.new {
      def inspect
        super.force_encoding(@path.encoding)
      end
    }
  end
end

module ObserverPathnameExtension
  class << self
    attr_accessor :n, :d

    def reset_counts!
      @n = @d = 0
    end

    def total
      n + d
    end

    def counts
      [n, d]
    end
  end

  def unlink
    super
    puts "rm #{to_s}" if ARGV.verbose?
    ObserverPathnameExtension.n += 1
  end
  def rmdir
    super
    puts "rmdir #{to_s}" if ARGV.verbose?
    ObserverPathnameExtension.d += 1
  end
  def make_relative_symlink src
    super
    puts "ln -s #{src.relative_path_from(dirname)} #{basename}" if ARGV.verbose?
    ObserverPathnameExtension.n += 1
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
