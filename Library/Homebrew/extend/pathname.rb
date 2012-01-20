require 'pathname'

# we enhance pathname to make our code more readable
class Pathname
  def install src
    case src
    when Array
      src.collect {|src| install_p(src) }
    when Hash
      src.collect {|src, new_basename| install_p(src, new_basename) }
    else
      install_p(src)
    end
  end

  def install_p src, new_basename = nil
    if new_basename
      new_basename = File.basename(new_basename) # rationale: see Pathname.+
      dst = self+new_basename
      return_value =Pathname.new(dst)
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

  # we assume this pathname object is a file obviously
  def write content
    raise "Will not overwrite #{to_s}" if exist? and not ARGV.force?
    dirname.mkpath
    File.open(self, 'w') {|f| f.write content }
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
  def extname
    /(\.(tar|cpio)\.(gz|bz2|xz))$/.match to_s
    return $1 if $1
    return File.extname(to_s)
  end

  # for filetypes we support, basename without extension
  def stem
    return File.basename(to_s, extname)
  end

  # I don't trust the children.length == 0 check particularly, not to mention
  # it is slow to enumerate the whole directory just to see if it is empty,
  # instead rely on good ol' libc and the filesystem
  def rmdir_if_possible
    rmdir
    true
  rescue SystemCallError => e
    raise unless e.errno == Errno::ENOTEMPTY::Errno or e.errno == Errno::EACCES::Errno
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
    out<<`/usr/bin/du -hd0 #{to_s} | cut -d"\t" -f1`.strip
  end

  # attempts to retrieve the version component of this path, so generally
  # you'll call it on tarballs or extracted tarball directories, if you add
  # to this please provide amend the unittest
  def version
    if directory?
      # directories don't have extnames
      stem=basename.to_s
    else
      # sourceforge /download
      if %r[((?:sourceforge.net|sf.net)/.*)/download$].match to_s
        stem=Pathname.new(dirname).stem
      else
        stem=self.stem
      end
    end

    # github tarballs, like v1.2.3
    %r[github.com/.*/(zip|tar)ball/v?((\d\.)+\d+)$].match to_s
    return $2 if $2

    # eg. https://github.com/sam-github/libnet/tarball/libnet-1.1.4
    %r[github.com/.*/(zip|tar)ball/.*-((\d\.)+\d+)$].match to_s
    return $2 if $2

    # dashed version
    # eg. github.com/isaacs/npm/tarball/v0.2.5-1
    %r[github.com/.*/(zip|tar)ball/v?((\d\.)+\d+-(\d+))$].match to_s
    return $2 if $2

    # underscore version
    # eg. github.com/petdance/ack/tarball/1.93_02
    %r[github.com/.*/(zip|tar)ball/v?((\d\.)+\d+_(\d+))$].match to_s
    return $2 if $2

    # eg. boost_1_39_0
    /((\d+_)+\d+)$/.match stem
    return $1.gsub('_', '.') if $1

    # eg. foobar-4.5.1-1
    # eg. ruby-1.9.1-p243
    /-((\d+\.)*\d\.\d+-(p|rc|RC)?\d+)$/.match stem
    return $1 if $1

    # eg. lame-398-1
    /-((\d)+-\d)/.match stem
    return $1 if $1

    # eg. foobar-4.5.1
    /-((\d+\.)*\d+)$/.match stem
    return $1 if $1

    # eg. foobar-4.5.1b
    /-((\d+\.)*\d+([abc]|rc|RC)\d*)$/.match stem
    return $1 if $1

    # eg foobar-4.5.0-beta1, or foobar-4.50-beta
    /-((\d+\.)*\d+-beta(\d+)?)$/.match stem
    return $1 if $1

    # eg. foobar4.5.1
    /((\d+\.)*\d+)$/.match stem
    return $1 if $1

    # eg foobar-4.5.0-bin
    /-((\d+\.)+\d+[abc]?)[-._](bin|stable|src|sources?)$/.match stem
    return $1 if $1

    # Debian style eg dash_0.5.5.1.orig.tar.gz
    /_((\d+\.)+\d+[abc]?)[.]orig$/.match stem
    return $1 if $1

    # brew bottle style e.g. qt-4.7.3-bottle.tar.gz
    /-((\d+\.)*\d+(-\d)*)-bottle$/.match stem
    return $1 if $1

    # eg. otp_src_R13B (this is erlang's style)
    # eg. astyle_1.23_macosx.tar.gz
    stem.scan(/_([^_]+)/) do |match|
      return match.first if /\d/.match $1
    end

    # erlang bottle style, booya
    # e.g. erlang-R14B03-bottle.tar.gz
    /-([^-]+)-bottle$/.match stem
    return $1 if $1

    nil
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

  def md5
    require 'digest/md5'
    incremental_hash(Digest::MD5)
  end

  def sha1
    require 'digest/sha1'
    incremental_hash(Digest::SHA1)
  end

  def sha2
    require 'digest/sha2'
    incremental_hash(Digest::SHA2)
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
    (dirname+readlink).exist?
  end

  # perhaps confusingly, this Pathname object becomes the symlink pointing to
  # the src paramter.
  def make_relative_symlink src
    self.dirname.mkpath
    Dir.chdir self.dirname do
      # TODO use Ruby function so we get exceptions
      # NOTE Ruby functions may work, but I had a lot of problems
      rv = system 'ln', '-sf', src.relative_path_from(self.dirname), self.basename
      unless rv and $? == 0
        raise <<-EOS.undent
          Could not create symlink #{to_s}.
          Check that you have permissions on #{self.dirname}
          EOS
      end
    end
  end

  def / that
    join that.to_s
  end

  def ensure_writable
    saved_perms = nil
    unless writable?
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
    system '/usr/bin/install-info', self.to_s, (self.dirname+'dir').to_s
  end

  def uninstall_info
    unless self.symlink?
      raise "Cannot uninstall info entry for unbrewed info file '#{self}'"
    end
    system '/usr/bin/install-info', '--delete', '--quiet', self.to_s, (self.dirname+'dir').to_s
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
  def mkpath
    super
    puts "mkpath #{to_s}" if ARGV.verbose?
    $d+=1
  end
  def make_relative_symlink src
    super
    puts "ln #{to_s}" if ARGV.verbose?
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
