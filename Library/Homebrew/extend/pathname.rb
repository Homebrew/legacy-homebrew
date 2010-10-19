#
# extend/pathname.rb - Extensions to Pathname for use with Homebrew.
#

require 'pathname'

class Pathname
  #
  # Move the specified source file to this path.
  # - Multiple source files or directories can be passed as an array.
  # - If installing to a subdirectory of this path, sources are passed as a
  #   hash with source => subdir_name.
  #
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

  #
  # Backend for install. Moves the source file into the new_basename
  # subdirectory of this path.
  #
  def install_p src, new_basename = nil
    if new_basename
      new_basename = File.basename(new_basename) # rationale: see Pathname.+
      dst = self + new_basename
      return_value = Pathname.new(dst)
    else
      dst = self
      return_value = self + File.basename(src)
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

    return_value
  end

  #
  # Writes the given content to the file at this pathname.
  #
  def write content
    raise "Will not overwrite #{to_s}" if exist? and not ARGV.force?
    dirname.mkpath
    File.open(self, 'w') {|f| f.write content }
  end

  #
  # Copy this file or directory to the specified destination path.
  #
  def cp dst
    if file?
      FileUtils.cp to_s, dst
    else
      FileUtils.cp_r to_s, dst
    end
    dst
  end

  #
  # Extend extname to work with supported double-extensions.
  #
  def extname
    /(\.tar\.(gz|bz2))$/.match to_s
    return $1 if $1
    File.extname(to_s)
  end

  #
  # For supported filetypes, returns the basename without extension.
  #
  def stem
    File.basename(to_s, extname)
  end

  #
  # Removes this directory if it is empty.
  #   This also avoids the children.length == 0 check, which is slow and
  #   possibly unreliable.
  #
  def rmdir_if_possible
    rmdir
    true
  rescue SystemCallError => e
    raise unless e.errno == Errno::ENOTEMPTY::Errno or e.errno == Errno::EACCES::Errno
    false
  end
  
  #
  # Recursively change this pathname's permissions to the given permissions.
  #
  def chmod_R perms
    require 'fileutils'
    FileUtils.chmod_R perms, to_s
  end

  #
  # Output the number of files and the human-readable size for this path.
  #
  def abv
    out=''
    n=`find #{to_s} -type f | wc -l`.to_i
    out<<"#{n} files, " if n > 1
    out<<`/usr/bin/du -hd0 #{to_s} | cut -d"\t" -f1`.strip
  end

  #
  # Attempt to retrieve the version component of this path.
  #   (Used to find the version of a tarball.)
  #
  #   NOTE: When adding to this method, please amend the unit test in
  #   ../tests/test_pathname.rb
  #
  def version
    if directory?
      # directories don't have extnames (e.g. ruby/1.9.1)
      stem = basename.to_s
    else
      stem = self.stem
    end
    
    # github tarballs are special
    # we only support numbered tagged downloads
    %r[github.com/.*/tarball/v?((\d\.)+\d+)$].match to_s
    return $1 if $1

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
    /-((\d+\.)+\d+[abc]?)[-.](bin|stable|src|sources?)$/.match stem
    return $1 if $1

    # Debian style eg dash_0.5.5.1.orig.tar.gz
    /_((\d+\.)+\d+[abc]?)[.]orig$/.match stem
    return $1 if $1

    # eg. otp_src_R13B (this is erlang's style)
    # eg. astyle_1.23_macosx.tar.gz
    stem.scan /_([^_]+)/ do |match|
      return match.first if /\d/.match $1
    end

    nil
  end
  
  #
  # Calculate the hash of this file using the specified digest method.
  #
  def incremental_hash hasher
    incr_hash = hasher.new
    self.open('r') do |f|
      while (buf = f.read(1024))
        incr_hash << buf
      end
    end
    incr_hash.hexdigest
  end

  #
  # Calculate the md5 hash of this file.
  #
  def md5
    require 'digest/md5'
    incremental_hash(Digest::MD5)
  end
  
  #
  # Calculate the sha1 sum of this file.
  #
  def sha1
    require 'digest/sha1'
    incremental_hash(Digest::SHA1)
  end
  
  #
  # Calculate the sha2 sum of this file.
  #
  def sha2
    require 'digest/sha2'
    incremental_hash(Digest::SHA2)
  end

  # The method to_str has been removed from ruby 1.9.
  if '1.9' <= RUBY_VERSION
    alias_method :to_str, :to_s
  end

  #
  # Change the working directory to this path (and do work).
  #
  def cd &work
    Dir.chdir(self, &work)
  end

  #
  # The subdirectories of this path.
  #
  def subdirs
    children.select {|child| child.directory? }
  end

  #
  # If this path references a symlink, the path to the file it describes.
  # Otherwise, this path.
  #
  def resolved_path
    self.symlink? ? dirname + readlink : self
  end
  
  #
  # True if this path (directly or indirectly) references a file that exists.
  #
  def resolved_path_exists?
    resolved_path.exist?
  end

  #
  # True if this pathname begin with the specified prefix, such as /usr/local.
  #
  def starts_with? prefix
    prefix = prefix.to_s
    self.to_s[0, prefix.length] == prefix
  end

  #
  # Create a relative symlink at this location that points to the given path.
  #
  def make_relative_symlink src
    self.dirname.mkpath
    Dir.chdir self.dirname do
      # TODO use Ruby function so we get exceptions
      # NOTE Ruby functions may work, but I had a lot of problems
      rv = system 'ln', '-sf', src.relative_path_from(self.dirname)
      unless rv and $? == 0
        raise <<-EOS.undent
          Could not create symlink #{to_s}.
          Check that you have permssions on #{self.dirname}
          EOS
      end
    end
  end

  # Using '/' also sense when appending to a pathname.
  alias_method :/, :+
end

#
# Extends a pathname to allow observation. Uses global variables $d and $n.
#   $n: the number of symlinks added or removed.
#   $d: the number of directories added or removed.
#
module ObserverPathnameExtension
  def unlink
    super
    puts "rm #{to_s}" if ARGV.verbose?
    $n += 1
  end
  def rmdir
    super
    puts "rmdir #{to_s}" if ARGV.verbose?
    $d += 1
  end
  def mkpath
    super
    puts "mkpath #{to_s}" if ARGV.verbose?
    $d += 1
  end
  def make_relative_symlink src
    super
    puts "ln #{to_s}" if ARGV.verbose?
    $n += 1
  end
end

# These should by the observing routine.
$n ||= 0
$d ||= 0
